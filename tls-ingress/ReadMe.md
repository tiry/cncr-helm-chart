## Install Cert-Manager in K8S cluster

    kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.1.0/cert-manager.yaml

It should deploy CRDs and start 3 pods in the `cert-manager` namespace

    kubectl get pods --namespace cert-manager

## Create the issuers resources

Staging issuer (for testing)

    kubectl create -f letsencrypt-staging-issuer.yaml

Production issuer

    kubectl create -f letsencrypt-prod-issuer.yaml

Technically the issuer need to be created in each of the tenant namespace, typically:

    kubectl create -n tenant1 -f letsencrypt-prod-issuer.yaml

## Add the needed lines in the ingres definition

Add annotations in the ingres descriptor:

    metadata:
      annotations:
        kubernetes.io/ingress.class: "nginx"    
        cert-manager.io/issuer: "letsencrypt-prod"

Add the tls entry in the ingress descriptor:

    tls:
    - hosts:
      - company-a.multitenant.nuxeo.com
      secretName: company-a-tls

## Cert-Issuers and namespaces

The Cert-Issuer needs to be created either in the target "tenant" namespace or in the kube-system namespace.

## RateLimits

Because of the Ratelimit (50 certificate requests / month) on the production issuer, it is advised to use the staging env for testing.

However, the staging env issues certificates with a Root CA that is not valide ...

see: https://letsencrypt.org/docs/rate-limits/

## Alternative option: Wildcard certificates

Because of the ratelimit, we are using a wildcard certificate on *.multitenant.nuxeo.com.

For this purpose, just add your certiciate in 2 PEM encoded files 

 - wildcard-cert.pem for the certificate
 - wildcard-key.pem for the private key

If you want to check that the certificate is readable and in the expected format:

    openssl x509 -in wildcard-cert.pem -text -noout

Then you need to create, for each namespace, a secret holding the certificate:

   ./create-tls-secret-from-pem.sh

This is a simple wrapper around

   kubectl create secret tls static-wildcard-tls -n tenant-ns \
    --cert=wildcard-cert.pem \
    --key=wildcard-key.pem

In this case, be sure that your ingress does not require the cert-manager and commented out the corresponding part:

    ingress:
    enabled: true
    annotations:
        nginx.ingress.kubernetes.io/affinity: cookie
        nginx.ingress.kubernetes.io/affinity-mode: persistent
        nginx.ingress.kubernetes.io/proxy-body-size: 100m
        kubernetes.io/ingress.class: "nginx"    
    #    cert-manager.io/issuer: "letsencrypt-staging"

If your wild card certificate was issued through intermediate CA it will not be an issue for the browser: they will automatically download the intermediate certificate, but it may not be the case for some clients like th JDK.

Trying to connect to TLS enpoint using wildcard certificate using intermediates will result in errors like:

    javax.net.ssl.SSLHandshakeException: PKIX path building failed: sun.security.provider.certpath.SunCertPathBuilderException: unable to find valid certification path to requested target

To solve that you need to get the full chain of certificates are append them all in the same pem file before creating the secret.

Typically:

    cat STAR_multitenant_nuxeo_com.crt > wildcard-cert-chain.pem
    cat USERTrustRSAAAACA.crt >> wildcard-cert-chain.pem
    cat SectigoRSADomainValidationSecureServerCA.crt >> wildcard-cert-chain.pem

Then you can use this pem in the command to create the secret:

    kubectl create secret tls static-wildcard-tls-chain -n my-tenant \
      --cert=wildcard-cert-chain.pem \
      --key=wildcard-key.pem

## References: 

https://cert-manager.io/docs/installation/kubernetes/

https://cloud.google.com/kubernetes-engine/docs/concepts/ingress-xlb

https://rancher.com/docs/rancher/v2.x/en/installation/resources/tls-secrets/

https://stackoverflow.com/questions/51572249/why-does-google-cloud-show-an-error-when-using-clusterip

