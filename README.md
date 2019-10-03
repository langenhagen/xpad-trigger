# Xpad-Trigger
A `bash` script and a `systemd` service that trigger user-scripts when `xpad` sticky notes change.

The `bash` script `xpad-trigger.sh` listens for changes to the files that store the contents of the
sticky notes from the sticky note application `xpad` and triggers user-defined executables in case
of modification.
One example use case is to back up sticky notes.

Please note, that `xpad` writes to its content-files several times a second when you edit the
according sticky note. This may lead to having incomplete character series, sentences or words in
the content-file at any time a trigger is called.

**Note:** I changed the path to the content-files to be watched for in the script `xpad-trigger.sh`
from the default path to a special path tailored to my system, since `inotify` avoids following
symlinks and I do more stuff with `xpad` sticky notes. Please consult the file `xpad-trigger.sh` for
further info and change it if necessary.


## Prerequisites
Besides `bash`, xpad-trigger requires `inotify-tools`. The service requires also `systemd`.

To install `inotify-tools` on `Debian` or `Ubuntu`, run:
```bash
sudo apt install -y inotify-tools;
```
`systemd` should be available on `Debian` and `Ubuntu` by default.


## Usage
`xpad-trigger` runs custom, user-created executables that match naming patterns of the content-files
from `xpad`.
This means, you have to do two things:
1. setup a custom trigger-script
2. run `xpad-trigger`

The following subsections explain the 2 steps.

### Custom Trigger Scripts
`xpad-trigger` runs user-defined scripts immediately when an `xpad` sticky note-related content-file
is written to.
These user-defined scripts can be executables of any kind.
They are invoked by `xpad-trigger` without any arguments.

In order to create a trigger-script for a certain `xpad` sticky note, do the following:

1. Identify the file that contains the text of the sticky note.
   Content-files reside in the directory `$HOME/.config/xpad` and have a scheme like `content-<id>`.

2. Name the script according to the scheme `<id>-trigger*` with `<id>` matching the concerning file
   `content-<id>`.
   `xpad-trigger` runs scripts of name `<id>-trigger*` that match the `<id>` part of the content
   file named `content-<id>`. E.g., a script called `HELLO-trigger.py` may be called whenever you
   type into the sticky note that belongs to the content-file `content-HELLO`.

3. Place the trigger-script into the directory `$HOME/xpad/trigger`.
   Create this directory if necessary.

4. Make the trigger-script executable. I.e., add a shebang at the top of the script and run:
```bash
   chmod +x <SCRIPTNAME>
```

`xpad-trigger` will detect new trigger-scripts on the fly and behaves well when scripts are
renamed or removed.

### Changing Xpad Content-File Names
You may change the names of the sticky notes's accompanying content-files in order to maintain a
better overview over your notes and triggers:

1. Shut down your `xpad` instance.
2. Change the names of the content-files from `content-<old_id>` to `content-<new_id>`.

3. Adjust the field `content` in the info-file that accompanies the content-file.
   Info-files are the files of the format `info-<info-id>`.
   The name part of the file `<info-id>` may or may not differ from the name part `<id>` from the
   content-files.
4. Optionally, rename the info-files similar to the content-files.

### Starting `xpad-trigger.sh`
Start the script like:
```bash
bash xpad-trigger.sh
```

You can detach the script from the terminal session and run it in the background:
```bash
nohup ./xpad-trigger.sh &
```

### Running `xpad-trigger` as a Service
The script `setup-systemd-service.sh` can set up the service on platforms that support `systemd`,
e.g. `Ubuntu`.
Running `xpad-trigger.sh` as a service allows for autostart and running in the backgorund.

To install the `systemd` service `xpad-trigger` on `Ubuntu`, run:
```bash
sudo bash setup-systemd-service.sh
```

This copies the script `xpad-trigger.sh` into the directory `/usr/local/bin` and the file
`xpad-trigger.service` into the directories of the `systemd` installation.
On other platforms than `Ubuntu`, you might have to adjust the setup-script.

After installation, you may control the service via typical `systemd` commands:
```bash
sudo systemctl enable xpad-trigger  # run service at system startup
sudo systemctl start xpad-trigger
sudo systemctl stop xpad-trigger
sudo systemctl restart xpad-trigger
sudo systemctl status xpad-trigger
```

If you want to make changes to the program, change the script and replace the script file in
`/usr/local/bin/`.


## Contributing
Work on your stuff locally, branch, commit and modify to your heart's content.
If there is anything you can extend, fix or improve, please do so!
Happy coding!


## TODO
