# BashIt ReadMe
---

<img src="https://igotaprinter.com/images/Bash-new.sh-600x600.png" align="right"
     alt="Cool Image" width="180" height="160">

BashIt is a high performance Command Line interface that offers a state-of-the-art messaging service using Object Orientation Programming.

* **Multi-room support** and **interactive chatroom**.
* **On demand** user/chat statistics <you can further elaborate with time stamps and what not>
  or another CI system to know if a pull request adds a massive dependency.
* **Modular** to fit different various use cases: connect with staff and faculty; enjoy conversations with friends.

// add your screenshot
<p align="center">
  <img src="./img/example.png" alt="Size Limit CLI" width="738">
</p>

With **Active Record**, bashIt will handle complex user/room relationships. Persistance is ensured.


## How It Works

BashIt is a CLI tool that runs off of Active Record and Rake. Simply run rake app inside app/models directory to activate tool.


## Usage

### Chat Applications

Suitable for applications that run on lightweight platforms and offers a solid, persistant solution to chat logs.

<details><summary><b>Show instructions</b></summary>

1. Install the presets:

    ```sh
    $ bundle install
    ```
    
2. Open command line session and execute ```rake console```, which will activate a pry session and allow for data base migrations (refer to db namespace in activate record).


