# Solsta Deployments Action for GitHub 

This project is a GitHub Action that uses Solid State Networks tools and services to deploy assets from a build to a CDN for downloading.  

The action is compatible with Windows, Linux, and OSX runners.  Windows self-hosted runners require git-bash (https://git-scm.com/) in the %PATH%.

## Variables

* **solsta_client_id:**     Client ID to authenticate usage of Solid State Networks console tools
* **solsta_client_secret:** Secret Key to authenticate usage of Solid State Networks console tools
* **console_version:**      Version of Solsta Console Tools to use
* **scripts_version:**      Version of Solsta Deploy Scripts to use
* **release_version:**      An environment variable or build parameter to use as a version within Solsta (optional)
* **notes_location:**       Release notes URL (optional)
* **working_directory:**    Relative path to folder containing deployable artifacts
* **target_product:**       Target product for deployment (case-sensitive)
* **target_environment:**   Target environment for deployment (case-sensitive)
* **target_repository:**    Target repository for deployment (case-sensitive)
* **hidden_files:**         List of hidden files in format '( "path1" "path2" etc.. )'
* **sync_attributes:**      Set to "true" to sync attributes from source files.
* **sync_timestamps:**      Set to "true" to sync timestamps from source files.
* **executable_files:**     List of executable files in format '( "path1" "path2" etc.. )'
* **included_files:**       List of include file path masks, format is 'path1/;/*/path/*mask'
* **excluded_files:**       List of exclude file path masks, format is 'path1/;/*/path/*mask'

## Using

Here is an example YAML Fragment in the steps section of a build

```yaml
    steps:
    - name: Deploy Build Assets from bin/ directory
      uses: snxd/deploy-github-deploy-action@v4
      with:
        solsta_client_id:  ${{ secrets.SOLSTA_CLIENT_ID }}
        solsta_client_secret:  ${{ secrets.SOLSTA_CLIENT_SECRET }}
        working_directory: 'bin/'
        console_version: '7.2.49'
        scripts_version: '3.10.0'
        release_version: '1.0'
        notes_location: 'https://release.notes.com/notes1.0.html'
        target_product: 'Emutil'
        target_environment: 'Java'
        target_repository: 'Bin'
        hidden_files: '( "bin/D64Search.jar" "bin/D64Mod.jar" )'
        sync_attributes: 'False'
        executable_files: '( "bin/D64Search.jar" "bin/D64Mod.jar" )'
        included_files: 'bin/*.jar'
        excluded_files: 'bin/*.txt'

```


## License
(C) 2022 Solid State Networks, LLC.  All Rights Reserved.
