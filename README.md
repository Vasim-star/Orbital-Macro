# Orbital-Macro

INSTALL GIT AND WATCH GIT VIDEOS ON VERSION CONTROLLING.

For Collaborators 
1) How to pull the project to your local repository:
    1. Open git bash where your project folder is:
      - Right click on project folder
      - Click on "Open git bash here"
    2. Git Initialize (if not already done) your project folder so that you can use git functionalities with it:
       - git init
    3. Pull the contents of the remote repository into your local repository branch (Could be master branch or other branches):
       - git pull https://github.com/Vasim-star/Orbital-Macro
    4. If your local repository is already linked with the remote and you want to pull the updates from the remote to local:
       - git pull

2) How to push changes onto the remote branches:
    1. Add the changed files onto the staging area:
       - git add "filename"
       or to add all files
       - git add .  
    2. Commit the changes with a short but comprehensive message:
       - git commit -m "type your message here"
    3. Push the changes to the remote repository:
       - git push -u origin branchname

3) How to make branches in local repository:
    1. If you are in the master branch and you want to make a branch from the master branch:
        - git branch "newbranchname"
    2. If you want to change branches:
        - git checkout "branchname"

4) How to merge branches:
    1. If you want to merge the changes of branch 2 with branch 1:
        - git checkout "branch 1"
        - git merge "branch 2"

NOTE: GIT IS COMPLICATED AT FIRST SO PRACTICE BEFORE GIVING ANY COMMANDS. THERE IS NO TIME TO ROLLBACK THE MISTAKES YOU MAKE. 
