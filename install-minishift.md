Minecraft servers minishift
===========================

The following steps should be preformed to install the everything on minishift:

```bash
 $> minishift config set memory 8192
 $> minishift config set cpus 4
 $> minishift start
 $> wget https://raw.githubusercontent.com/fabric8-launcher/launcher-openshift-templates/master/openshift/launcher-template.yaml
```

Go to the minishift console (developer/developer) and import the `launcher-template.yaml` into a new project (or My Project) using Add to Project > Import YAML/JSON.  Use the following settings when you *Process the template* (you don't have to Save the Template), after you create a [Personal access token on GitHub](https://github.com/settings/tokens) with all "repo" and "admin:repo_hook" scopes:

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

Open the launcher-frontend-myproject.192.168...nip.io, and Launch your Project, Use Continuous Delivery (NOT Build and run locally), Plugin Example, Sponge Server, set any OpenShift Project name.  This will create a repo of that name on the GitHub account you created a token for above, and a new project for it in your local OpenShift instance. 

If the `minecraft-server-...` deployment fails to become Active, then Edit its Health Checks and delete its Readiness Probe.

Forward the Minecraft port from your localhost into Minishift, but first change to your new project first:

```bash
 $> oc project test-minecraft
 $> oc port-forward minecraft-server-<hash> 25565:25565
```

To edit the Minecraft plug in in an online Web IDE, you can now install the Che [minishift addon](https://github.com/minishift/minishift-addons/tree/master/add-ons/che):

```
git clone git@github.com:minishift/minishift-addons.git
cd minishift-addons
minishift addons install add-ons/che
minishift addons enable che
minishift addons apply che
```

If apply not work, then deploy Che from the catalog by going to <console url> and select `eclipse-che`.  
 
Now open che-mini-che.192.168...nip.io, and Add or Import Project (the one wthich the launcher created earlier), from Git (connect your GitHub account is broken, in Che 6.3.0), Create, Open in IDE.

```
Add to Project: Create project
Project Name: mini-che
Che service domain name: <empty>
GitHub client ID: <your id>
GitHub client secret: <your created secret>
```

Open the pom.xml and change the source-sync-maven-plugin configuration serverUri from ws://localhost:9191 to the Application Route shown on minecraft-server, e.g. ws://minecraft-server-test-minecraft.192.168.42.145.nip.io/ (NB replace http by: ws: and your IP).  Now synchronise the change made in the local Che workspace to the Minecrafter server pod by running the the source-sync-maven-plugin from the Terminal in Che:

    cd minecraft-test/
    mvn -Psync validate
