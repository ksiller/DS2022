# Getting Started

Complete the following steps before the end of week 1. Visit office hours if you need help.

**Note:** Some tasks may cause errors or require additional settings or configuration. This is to be expected. Google, StackOverflow, and your classmates can be helpful, as instructional staff do not have the capacity for desktop support. You may already have some of these completed from previous classes.

### Services

- [ ] Create a **[GitHub](https://github.com/)** account if you do not already have one.
  - [ ] [Enable 2FA](https://github.com/settings/security) for your account. This is required.
  - [ ] [Enroll in GitHub Education](https://education.github.com/discount_requests/application) as a student and verify. This is required. More information about [verification](https://docs.github.com/en/education/explore-the-benefits-of-teaching-and-learning-with-github-education/github-education-for-students/apply-to-github-education-as-a-student) is available.
- [ ] Sign up for a **[Free Tier AWS Account](https://aws.amazon.com/free/)**. It provides $200 worth of credit; this should be more than plenty for this course. The account expires after 6 months or when all credits are used, which ever comes first. When you sign up, this will be your root account; keep these credentials secure. For our course work in AWS you will set up yourself as a new user. You will learn this in the Cloud Computing module. For now the root account is sufficient.
- [ ] Create a free **[Docker account](https://app.docker.com/signup)** to use with Rancher Desktop.



### Software

- [ ] MacOS users: Find the **Terminal** app (in Applications --> Utilities). You may want to add it to your dock.
- [ ] Windows users: **[Install and set up WSL](https://learn.microsoft.com/en-us/windows/wsl/install)**, the Windows Subsystem for Linux. The default WSL installation will create an Ubuntu environment for you. The username and password you create within WSL does not have to match your Windows username/password. Be sure to complete the WSL installation before you install Cursor (see below).
- [ ] Install **[Rancher Desktop](https://docs.rancherdesktop.io/getting-started/installation/)** on your laptop. Rancher Desktop does not have a sign-in screen like Docker Desktop; you connect your Docker account from the terminal after setup.
  1. Install and open Rancher Desktop. Let it finish its first-time setup.
  2. Open **Preferences** → **Container Engine** and select **Moby (dockerd)** as the container runtime.
  3. Open Terminal and run `docker login`. Follow the browser/device-code flow, or enter your Docker Hub username and password when prompted.
  4. Confirm the login worked: `docker info` should run without errors.

  You will not need `docker login` for every lab, but your Docker account must exist and this step verifies that Rancher Desktop and the Docker CLI are working.
- [ ] Install the `git` **[command line](https://git-scm.com/downloads)** for your OS. Windows users may want to install it both in Windows and within WSL. 
- [ ] Install [`jq`](https://jqlang.github.io/jq/) for your OS. Confirm it works with `jq --version`.
  - MacOS users: install with [Homebrew](https://brew.sh/):
    ```
    brew install jq
    ```
  - Windows users: install in WSL (your primary development environment):
    ```
    sudo apt update
    sudo apt install -y jq
    ```
- [ ] Install **[Cursor](https://cursor.com/lp/agent-workflow?utm_source=google_paid&utm_medium=paid&utm_campaign=%5BSearch%5D%20%5BBrand%5D%20%5BEN%5D%20%5BCore%20T1%5D%20%5BBroad%5D%20%5BVBB%5D%20Brand&utm_term=cursor%20download&utm_content=817238668313&cc_platform=google&cc_campaignid=23656700841&cc_adgroupid=195242436238&cc_adid=817238668313&cc_keyword=cursor%20download&cc_matchtype=b&cc_device=c&cc_network=g&cc_placement=&cc_location=9008337&cc_adposition=&cc_gclid=CjwKCAjwwL_UBhAjEiwAEhuT5DC6c-BXAZT8lmrNp6wkrQsmQiMYrXubYSVRgWIbXYM7FbmBp25mKxoC_2cQAvD_BwE&gad_source=1&gad_campaignid=23656700841&gbraid=0AAAABAkdGgT8gpaz_RereVQLcbTXvZIgO&gclid=CjwKCAjwwL_UBhAjEiwAEhuT5DC6c-BXAZT8lmrNp6wkrQsmQiMYrXubYSVRgWIbXYM7FbmBp25mKxoC_2cQAvD_BwE)**, a fork of the popular Visual Studio Code IDE (integrated development environment), in your primary OS. (That is, *Windows users install Cursor on the Windows side, not in WSL.*). Sign up for the free "Hobby" tier. 
- [ ] Inside Cursor, install the `UVA Data Science Extension Pack` following these steps. The extensions enhance the IDE's functionality.
  1. [Download the extension](https://ds2022-fall26.s3.us-east-1.amazonaws.com/uva-school-of-data-science.sds-vscode-0.1.10.vsix) file to your computer.
  2. Open Cursor. Cursor has two principal window types: `Agents Window` and `IDE Window`. Check the items in the `File` menu: 
    - If the `File` menu has `Switch to Agent Windows` it means you're in the `IDE` mode. That's what we want, skip to step 3. 
    - If the `File` menu has `Open IDE`, click on it to get into IDE mode. Continue with step 3.
  3. In the IDE window, open the Command Palette: **Cmd+Shift+P** (Mac) or **Ctrl+Shift+P** (Windows/Linux).
  4. Type: **Extensions: Install from VSIX…**, hit Enter/Return.
  5. Select the `.vsix` file you just downloaded.
  6. Reload the window when prompted (or **Developer: Reload Window**).
  7. Open the Extensions view (**Cmd+Shift+X**) and search for the extension name to confirm it is installed and enabled.



### Python

- [ ] Find Python3 on your laptop. Version 3.9 or higher is preferable (3.14 is the latest stable release, 3.7 has already reached its end of life and 3.8 is close to that). You can see what version you have installed from your terminal:
  ```
    $ python3 -V
  ```
    If you do not have Python installed, then:

- [ ] MacOS users install from [Python.org](https://www.python.org/downloads/) or by using `homebrew`.
- [ ] Windows users install from [Python.org](https://www.python.org/downloads/).
- [ ] Windows users will also develop within WSL, where you can install Python3 with:
  ```
    $ sudo apt update
    $ sudo apt install -y python3 python3-pip
  ```
    Once you have a working version of Python on your laptop you need to configure Cursor with the path to your local Python. Try creating a sample Python project and making this connection yourself.

