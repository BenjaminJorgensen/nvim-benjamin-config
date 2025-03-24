function ff --wraps='firefox & disown' --description 'alias firefox=firefox-developer-edition & disown'
  firefox-developer-edition & disown $argv
end
