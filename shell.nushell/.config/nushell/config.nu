# config.nu
#
# Installed by:
# version = "0.101.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.
use std/util "path add"

#=== CONFIG ===
$env.config.buffer_editor = "hx"
$env.config.edit_mode = "vi"

#=== ENV ===
$env.JAVA_HOME = "/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home"

$env.LDFLAGS = "-L/opt/homebrew/opt/icu4c/lib -L/opt/homebrew/opt/flex/lib"
$env.CPPFLAGS = "-I/opt/homebrew/opt/icu4c/include -I/opt/homebrew/opt/flex/include"
$env.PKG_CONFIG_PATH = ["/opt/homebrew/opt/icu4c/lib/pkgconfig"]

$env.ANTHROPIC_API_KEY = (security find-generic-password -gs "ANTHROPIC_API_KEY" -w)

#== PATH ==
$env.path ++= [($env.JAVA_HOME | path join "bin")]

$env.path ++= ["/usr/local/bin"]
$env.path ++= ["~/.local/bin"]
$env.path ++= ["~/.bun/bin"]
$env.path ++= ["~/.nvm/versions/node/v22.11.0/bin"]
$env.path ++= ["/opt/homebrew/bin", "/opt/homebrew/sbin"]
$env.path ++= ["/opt/homebrew/lib/node_modules"]
$env.path ++= ["/opt/homebrew/Cellar/node/24.5.0/lib/node_modules"]
$env.path ++= ["/opt/homebrew/Cellar/node/24.5.0/lib/node_modules/yarn/bin"]
$env.path ++= ["/opt/homebrew/Cellar/node/24.5.0/lib/node_modules/typescript/bin"]
$env.path ++= ["~/.yarn/bin"]

$env.path ++= ["/opt/homebrew/lib/ruby/gems/3.4.0/bin"]
$env.path ++= ["/opt/homebrew/opt/ruby/bin"]
$env.path ++= ["/Library/apache-maven-3.9.9/bin"]

$env.path ++= ["/opt/homebrew/opt/icu4c/bin", "/opt/homebrew/opt/icu4c/sbin"]

# $env.path ++= ["/Applications/Postgres.app/Contents/Versions/latest/bin"]
$env.path ++= ["/opt/homebrew/opt/postgresql@17/bin"]

$env.path ++= ["/Library/TeX"]
$env.path ++= ["/Library/Frameworks/Python.framework/Versions/3.13/bin"]

$env.path ++= ["/Library/NuSMV-2.6.0-Darwin/bin"]
$env.path ++= ["/Applications/Visual Studio Code.app/Contents/Resources/app/bin"]

path add (brew --prefix bison | path parse | path join "bin")
path add (brew --prefix flex  | path parse | path join "bin")

source ~/.zoxide.nu

# jj util completion nushell | save completions-jj.nu
#use completions-jj.nu *  # Or `source completions-jj.nu`


#=== COMMANDS ===
def netstat-listen [] {
  netstat -Watnlv | grep LISTEN | awk '{"ps -o comm= -p " $9 | getline procname;colred="\033[01;31m";colclr="\033[0m"; print cred "proto: " colclr $1 colred " | addr.port: " colclr $4 colred " | pid: " colclr $9 colred " | name: " colclr procname;  }' | column -t -s "|"
}

def "sys ports" [] {
  netstat -anlv | lines | where { |line| $line =~ "LISTEN" } | str join (char newline) | from ssv -n
    | where { |row| $row.column10 != null }
    | each { |row|
        let pid = ($row.column10 | into int)
        let process_name = try {ps | where pid == $pid | get name | first} catch { "(Unknown)" }
        {
          proto: $row.column0
          addr_port: $row.column3
          pid: $pid
          name: $process_name
        }
      }
    | table
}
