# Solsta Deployments Action for GitHub

This project is a GitHub Action that uses Solid State Networks tools and services to deploy assets from a build to a CDN for downloading.  

## Variables

* **solsta_client_id:**     Client ID to authenticate usage of Solid State Networks console tools
* **solsta_client_secret:** Secret Key to authenticate usage of Solid State Networks console tools
* **console_version:**      Version of Solsta Console Tools to use
* **scripts_version:**      Version of Solsta Deploy Scripts to use
* **release_version:**      An environment variable or build parameter to use as a version within Solsta (optional)
* **working_directory:**    Relative path to folder containing deployable artifacts
* **target_product:**       Target product for deployment (case-sensitive)
* **target_environment:**   Target environment for deployment (case-sensitive)
* **target_repository:**    Target repository for deployment (case-sensitive)

## Using

Here is an example YAML Fragment in the steps section of a build:

```yaml
    steps:
    - name: Deploy Build Assets from bin/ directory
      uses: snxd/deploy-github-deploy-action@main
      with:
        working_directory: 'bin/'
        console_version: '6.1.2.51'
        scripts_version: '3.7.18'
        release_version: '1.0'
        target_product: 'Emutil'
        target_environment: 'Java'
        target_repository: 'Bin'
        solsta_client_id:  ${{ secrets.SNXD_CLIENT_ID }}
        solsta_client_secret:  ${{ secrets.SNXD_CLIENT_SECRET }}

```


## License
(C) 2022 Solid State Networks, LLC.  All Rights Reserved.
