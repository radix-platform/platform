#!/bin/sh

# Preserve new files
install_file() {
  NEW="$1"
  OLD="`dirname $NEW`/`basename $NEW .new`"
  # If there's no file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "`cat $OLD | md5sum`" = "`cat $NEW | md5sum`" ]; then # toss the redundant copy
    rm $NEW
  fi
  # Otherwise, we leave the .new copy for the admin to consider...
}


# arg 1:  the new package version
pre_install() {
  /bin/true
}

# arg 1:  the new package version
post_install() {
  install_file var/lib/bsdgames/hack/record.new
  install_file var/lib/bsdgames/phantasia/characs.new
  install_file var/lib/bsdgames/phantasia/gold.new
  install_file var/lib/bsdgames/phantasia/lastdead.new
  install_file var/lib/bsdgames/phantasia/mess.new
  install_file var/lib/bsdgames/phantasia/monsters.new
  install_file var/lib/bsdgames/phantasia/motd.new
  install_file var/lib/bsdgames/phantasia/scoreboard.new
  install_file var/lib/bsdgames/phantasia/void.new
  install_file var/lib/bsdgames/atc_score.new
  install_file var/lib/bsdgames/battlestar.log.new
  install_file var/lib/bsdgames/cfscores.new
  install_file var/lib/bsdgames/criblog.new
  install_file var/lib/bsdgames/robots_roll.new
  install_file var/lib/bsdgames/saillog.new
  install_file var/lib/bsdgames/snake.log.new
  install_file var/lib/bsdgames/snakerawscores.new
  install_file var/lib/bsdgames/tetris-bsd.scores.new

  rm -f var/lib/bsdgames/hack/record.new
  rm -f var/lib/bsdgames/phantasia/characs.new
  rm -f var/lib/bsdgames/phantasia/gold.new
  rm -f var/lib/bsdgames/phantasia/lastdead.new
  rm -f var/lib/bsdgames/phantasia/mess.new
  rm -f var/lib/bsdgames/phantasia/monsters.new
  rm -f var/lib/bsdgames/phantasia/motd.new
  rm -f var/lib/bsdgames/phantasia/scoreboard.new
  rm -f var/lib/bsdgames/phantasia/void.new
  rm -f var/lib/bsdgames/atc_score.new
  rm -f var/lib/bsdgames/battlestar.log.new
  rm -f var/lib/bsdgames/cfscores.new
  rm -f var/lib/bsdgames/criblog.new
  rm -f var/lib/bsdgames/robots_roll.new
  rm -f var/lib/bsdgames/saillog.new
  rm -f var/lib/bsdgames/snake.log.new
  rm -f var/lib/bsdgames/snakerawscores.new
  rm -f var/lib/bsdgames/tetris-bsd.scores.new
}

# arg 1:  the new package version
# arg 2:  the old package version
pre_update() {
  /bin/true
}

# arg 1:  the new package version
# arg 2:  the old package version
post_update() {
  post_install
}

# arg 1:  the old package version
pre_remove() {
  /bin/true
}

# arg 1:  the old package version
post_remove() {
  rm -rf var/lib/bsdgames
}


operation=$1
shift

$operation $*
