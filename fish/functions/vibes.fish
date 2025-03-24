function vibes --wraps='ncspot' --description 'Music vibes'
    kitty sh -c "kitty-full cava" &
    hyprctl dispatch exec "[float exact] kitty sh -c 'ncspot'"
    # set WINDOW (hyprctl clients | grep -i " sh:" | awk '{print $2}')
    # notify-send $WINDOW $WINDOW
    hyprctl dispatch resizeactive 10% 10%
    # hyprctl dispatch movewindow center
        
end
