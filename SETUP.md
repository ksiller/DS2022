# Getting Started

Complete the following steps before the end of week 1.

**Note:** Some tasks may cause errors or require additional settings or configuration. This is to be expected. Google, StackOverflow, and your classmates can be helpful, as instructional staff do not have the capacity for desktop support. You may already have some of these completed from previous classes.

### Services

- [ ] Create a [**GitHub**](https://github.com/) account if you do not already have one.
    - [ ] [Enable 2FA](https://github.com/settings/security) for your account. This is required.
    - [ ] [Enroll in GitHub Education](https://education.github.com/discount_requests/application) as a student and verify. This is required. More information about [verification](https://docs.github.com/en/education/explore-the-benefits-of-teaching-and-learning-with-github-education/github-education-for-students/apply-to-github-education-as-a-student) is available.
- [ ] Create an [**AWS Account**](https://signin.aws.amazon.com/signup?request_type=register). This requires payment for any services used. I recommend buying a prepaid credit card ($50-$100 max) and using it to create your new Amazon Web Services account with the “Free Tier.” This course should incur $30-40 of charges at the most.
- [ ] Create a free [**Docker account**](https://app.docker.com/signup) to use with Docker Desktop.

### Software

- [ ] <img src="https://icons.iconarchive.com/icons/martz90/circle/128/apple-2-icon.png" width="24" height="24"> MacOS users: Find the **Terminal** app (in Applications --> Utilities). You may want to add it to your dock.
- [ ] <img src="https://icons.iconarchive.com/icons/martz90/circle/128/windows-8-icon.png" width="24" height="24"> Windows users: [**Install and set up WSL**](https://learn.microsoft.com/en-us/windows/wsl/install), the Windows Subsystem for Linux. The default WSL installation will create an Ubuntu environment for you. The username and password you create within WSL does not have to match your Windows username/password. Be sure to complete the WSL installation before you install VS Code.
- [ ] Install [**Rancher Desktop**](https://docs.rancherdesktop.io/getting-started/installation/) on your laptop and sign in using the Docker account you created above. We will use Moby (dockerd) as Container runtime. More to come; just complete the installation for now.
- [ ] Install the [**`git` command line**](https://git-scm.com/downloads) for your OS. Windows users may want to install it both in Windows and within WSL. 
- [ ] Install [**`jq`**](https://jqlang.github.io/jq/) for your OS.
- [ ] Install [**VS Code**](https://code.visualstudio.com/), the free IDE (integrated development environment) in your primary OS. (That is, Windows users install VS Code on the Windows side, not in WSL.) The links below will open each plugin page within VS Code; then click on "Install" from that page.
- [ ] Install the [**UVA Data Science Extension Pack**](https://marketplace.visualstudio.com/items?itemName=uva-school-of-data-science.sds-vscode) plugin from the SDS. This will install all the above extensions plus a few extras.

### Python

- [ ] Find Python3 on your laptop. Version 3.9 or higher is preferable (3.14 is the latest stable release, 3.7 has already reached its end of life and 3.8 is close to that). You can see what version you have installed from your terminal:

        $ python3 -V

    If you do not have Python installed, then:

- [ ] <img src="https://icons.iconarchive.com/icons/martz90/circle/128/apple-2-icon.png" width="24" height="24"> MacOS users install from [Python.org](https://www.python.org/downloads/) or by using `homebrew`.
- [ ] <img src="https://icons.iconarchive.com/icons/martz90/circle/128/windows-8-icon.png" width="24" height="24"> Windows users install from [Python.org](https://www.python.org/downloads/).
- [ ] <img src="https://icons.iconarchive.com/icons/martz90/circle/128/windows-8-icon.png" width="24" height="24"> Windows users will also develop within WSL, where you can install Python3 with:

        $ sudo apt update
        $ sudo apt install -y python3 python3-pip

    Once you have a working version of Python on your laptop you need to configure VS Code with the path to your local Python. Try creating a sample Python project and making this connection yourself.
