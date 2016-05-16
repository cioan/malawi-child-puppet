malawi-child-puppet
===================

puppet script that installs and configures a Windows based sync child server

puppet apply --verbose --logdest=console --modulepath=./modules manifests\site.pp



Installing a PIH-EMR Mental Health Instance
===========================================

Prepping the Flash Drive
------------------------

1) Checkout master branch of this module and copy to a flash drive in a new top-level directory /mental-health

2) SFTP to amigo.pih-emr.org and download "/home/backups/binaries/mental-health/hieradata/common.yawl"
    Copy this common.yawl over to the flash drive, replacing the default one in hieradata/common.yawl

3) Also from amigo.pih-emr.org download "/home/backups/binaries/mental-health/bin/*" (you can fetch an entire directory structure using sftp using "get -r", or you may want to zip up the entire bin directory first)
    Create a new directory on the flash drive, "/mental-health/bin" and copy over the contents of the directory downloaded in the previous step

4) Copy the MH "gold" version of OpenMRS core and modules you wish to install into "/mental-health/bin/openmrs" and "/mental-health/bin/openmrs/modules" replacing the existing war and omods
    NOTE: do **not** replace the base sql file (openmrs.sql.zip) found in the /mental-health/bin/openmrs directory (which you downloaded in step #3)
    You can find these on the Bamboo server at: "/home/emradmin/mental-health/deployment/"
    (if necessary, promote the latest PIH-EMR unstable deploy to Mental Health by running the "promote latest to mental health" bamboo build project)


Installing from the Flash Drive
-------------------------------

Prerequiste--Internet connectiviy will be required, in particular for steps #6 & #7

0) Close all applications and reboot the machine

1) Log on as the local admin account (e.g. PIH Windows user)

2) Copy from the USB the entire mental-health folder to c:\

3) Install puppet
    Click Start and search for "cmd." Right click on the Command Prompt and choose to "Run as Administrator."
    cd c:\mental-health
    Type installPuppet.bat (this includes now installing Window Resource Kit Tools too)
    If a dialog box says there are compatibility issues, allow the install to continue ("Run Program"). 
    Use the defaults and agree to the license agreement.
    Close any Command.exe windows that are already opened
    Ensure puppet installed okay: Click Start and search for "cmd." Right click on the Command Prompt and choose to "Run as Administrator."
    Type: "puppet --version" It should say something like 3.6.2
    Type: "facter" It should list a bunch of information
    If either of these checks fail, you need to quit the installation
    Type: "whoami"  Note the username (the value after the "\" )

3) Ensure you are using the correct configuration file
    Open Notepad and then open this file: c:\mental-health\hieradata\common.yaml
    (If the file doesn't display correctly you may need to install Notepad++)
    Change the windows_openmrs_user to the name of the Local Admin user that is logged on (the value you recorded at the end of Step 3)
    Save the changes to the file

4) Install OpenMRS
    Close all existing command prompts
    Open a new command prompt (go to start and type cmd and right click on cmd.exe and choose to "Run as Administrator")
    Type cd c:\mental-health\
    Type: install.bat
    **This command will take several minutes to run**
    If the install.bat outputs any red messages please stop and debug. Do not continue to the next step.
    Wait until the script finishes (it will display a line like "Notice: Finished catalog run in 346.20 seconds")

5) Verify OpenMRS has been installed
   **After execution of install.bat is complete, wait 10 minutes to allow OpenMRS to start up for the first time**
    Click on newly-created desktop shortcut "OpenMRS Sante Mentale"  (the browser will show the page as "connecting" until OpenMRS starts up)
    Make sure you are able to log on the OpenMRS with the "admin" user and **provided password**

6) Confirm local identifier pool has picked up identifiers from the remote identifier source
    (The refill task only runs every 5 minutes, so it may not immediately have identifiers, but **after 5 minutes with Internet connectivity** it should).
    Log in to OpenMRS as the Admin user
    Go to: http://localhost:8080/openmrs/module/idgen/manageIdentifierSources.list
    Click "Voir" next to "Local Pool of ZL Identifiers"
    Confirm that "Quantity Available" is greater than 0 (there should be 1000 identifiers, I believe)

7) Update OpenMRS software
    Windows->All Programs->OpenMRS->Check for OpenMRS updates, right click, run as Administrator
    When run for the first time all *.omod and war files are downloaded
    When prompted type "Y" to install the updates
    
8) Schedule Daily Backups 
    Windows->All Programs->OpenMRS->Schedule OpenMRS backups, right click, run as Administrator
    
9) Add new user account(s) as necessary
    Log back into OpenMRS (it will take a few minutes for it to come up again if it installed updates in step #7)
    From the Home Page:
    Administration système -> Gérer les comptes -> Créer un compte
    Enter First and Last Name and Gender
    Click on  Créer un compte utilisateur
    Enter username and password
    Niveau de privilège = Plein
    Langue par défaut = User's choice of Language
    Standard user should have the following Capacités:
    - Privilèges d'archiviste/commis
    - Privilèges du psychologue
    - Privilèges MEQ
    Type de prestataire is most likely Psychologue