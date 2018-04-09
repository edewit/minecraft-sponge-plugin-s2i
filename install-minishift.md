Minecraft servers minishift
===========================

The following steps should be preformed to install the everything on minishift:

```bash
 $> minishift start --cpus 4 --memory=4096
 $> wget https://raw.githubusercontent.com/fabric8-launcher/launcher-openshift-templates/master/openshift/launcher-template.yaml
```
Go to the minishift console and import the `launcher-template.yaml` into a new project.
Use the following settings when you process the template:

```
Your GitHub username: <your github username>
Your GitHub Mission Control access token: <create one on github and fill it in here>
Target OpenShift API URL: <current url e.g. https://192.168.42.64:8443/>
Target OpenShift Console URL: <current url with /console e.g. https://192.168.42.64:8443/console >
OpenShift user name: developer
OpenShift password: developer
The URL (with the /auth part) of a Keycloak installation to perform SSO: <empty>
KeyCloak Realm: <empty>
Segment Token: <empty>
Catalog Git Repository: https://github.com/edewit/booster-catalog.git
Catalog Git Reference: minecraft-runtime
Catalog Reindex Token: <empty>
Booster Environment: <empty>
the rest as already set preset
```

Install che [minishift addon](https://github.com/minishift/minishift-addons/tree/master/add-ons/che)
Deploy che from  the catalog by going to <console url> and select `eclipse-che`

```
Add to Project: Create project
Project Name: mini-che
Che service domain name: <empty>
GitHub client ID: <your id>
GitHub client secret: <your created secret>
```

Open the launcher go to the launcher project on minishift and open the external link e.g. http://launcher-frontend-launcher.<your ip>.nip.io
Press next a couple of times and enter a project name e.g. `minishift-minecraft-plugin`
  
```bash
 $> oc port-forward minecraft-server-<hash> 25565:25565
```
