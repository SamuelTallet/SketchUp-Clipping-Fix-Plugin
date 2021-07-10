# Clipping Fix extension for SketchUp.
# Copyright: © 2021 Samuel Tallet <samuel.tallet arobase gmail.com>
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3.0 of the License, or
# (at your option) any later version.
# 
# If you release a modified version of this program TO THE PUBLIC,
# the GPL requires you to MAKE THE MODIFIED SOURCE CODE AVAILABLE
# to the program's users, UNDER THE GPL.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
# 
# Get a copy of the GPL here: https://www.gnu.org/licenses/gpl.html

require 'sketchup'
require 'win32ole'

# Clipping Fix plugin namespace.
module ClippingFix

    # Helps to interact with SketchUp "Camera" window.
    module CameraWindow

        # Action code to send to open window.
        OPEN = 10624

        TITLE = TRANSLATE['Camera']

        # Windows Scripting Host instance.
        WSH = WIN32OLE.new('Wscript.Shell')

        # Keystroke to send to close window.
        CLOSE_KEY = '{ESC}'

        # Keystrokes to send to tick "Force" in window first time.
        #
        # I don't know why... first window opened after
        # SketchUp start has first field (Eye) focused.
        FIRST_CHECK_KEYS = [
            '{TAB}', # Focus "Dir"
            '{TAB}', # Focus "Up"
            '{TAB}', # Focus "Fov(H)"
            '{TAB}', # Focus "Fov = H"
            '{TAB}', # Focus "W/H"
            '{TAB}', # Focus "2D"
            '{TAB}', # Focus "cx"
            '{TAB}', # Focus "cy"
            '{TAB}', # Focus "Scale"
            '{TAB}', # Focus "GL Fov"
            '{TAB}', # Focus "Near"
            '{TAB}', # Focus "Far"
            '{TAB}', # Focus "Force"
            '{+}',   # Check "Force"
            '{TAB}', # Focus "Eye"
            '{TAB}', # Focus "Dir"
            '{TAB}', # Focus "Up"
            '{TAB}', # Focus "Fov(H)"
            '{TAB}', # Focus "Fov = H"
            '{TAB}', # Focus "W/H"
            '{TAB}', # Focus "2D"
            '{TAB}', # Focus "cx"
            '{TAB}', # Focus "cy"
            '{TAB}', # Focus "Scale"
            '{TAB}', # Focus "GL Fov"
            '{TAB}', # Focus "Near"
            '1'      # Input `1`
        ].join

        # First window open?
        @@first_open = true

        # Keystrokes to send to tick "Force" in window.
        CHECK_KEYS = [
            '{TAB}', # Focus "Eye"
            '{TAB}', # Focus "Dir"
            '{TAB}', # Focus "Up"
            '{TAB}', # Focus "Fov(H)"
            '{TAB}', # Focus "Fov = H"
            '{TAB}', # Focus "W/H"
            '{TAB}', # Focus "2D"
            '{TAB}', # Focus "cx"
            '{TAB}', # Focus "cy"
            '{TAB}', # Focus "Scale"
            '{TAB}', # Focus "GL Fov"
            '{TAB}', # Focus "Near"
            '{TAB}', # Focus "Far"
            '{TAB}', # Focus "Force"
            '{+}',   # Check "Force"
            '{TAB}', # Focus "Eye"
            '{TAB}', # Focus "Dir"
            '{TAB}', # Focus "Up"
            '{TAB}', # Focus "Fov(H)"
            '{TAB}', # Focus "Fov = H"
            '{TAB}', # Focus "W/H"
            '{TAB}', # Focus "2D"
            '{TAB}', # Focus "cx"
            '{TAB}', # Focus "cy"
            '{TAB}', # Focus "Scale"
            '{TAB}', # Focus "GL Fov"
            '{TAB}', # Focus "Near"
            '1'      # Input `1`
        ].join

        # Keystrokes to send to untick "Force" in window.
        UNCHECK_KEYS = [
            '{TAB}', # Focus "Eye"
            '{TAB}', # Focus "Dir"
            '{TAB}', # Focus "Up"
            '{TAB}', # Focus "Fov(H)"
            '{TAB}', # Focus "Fov = H"
            '{TAB}', # Focus "W/H"
            '{TAB}', # Focus "2D"
            '{TAB}', # Focus "cx"
            '{TAB}', # Focus "cy"
            '{TAB}', # Focus "Scale"
            '{TAB}', # Focus "GL Fov"
            '{TAB}', # Focus "Near"
            '{TAB}', # Focus "Far"
            '{TAB}', # Focus "Force"
            '{-}'    # Uncheck "Force"
        ].join

        # Supposed status of "Force" checkbox in window.
        #
        # TODO: Get real status?
        @@force_checked = false

        # Opens window.
        #
        # @param [Boolean] minimize
        # @raise [ArgumentError]
        # 
        # @return [Boolean] true on success, false on fail.
        def self.open(minimize)

            raise ArgumentError, 'Minimize parameter must be a Boolean'\
                unless minimize == true || minimize == false

            if Sketchup.send_action(OPEN)

                if minimize
                    # When you open consecutively window, it minimizes.
                    return Sketchup.send_action(OPEN)
                else
                    return true
                end

            end

            false

        end

        # Focus window if it's open.
        #
        # @return [Boolean] true on success, false on fail.
        def self.open?

            WSH.AppActivate(TITLE)

        end

        # Sends keystrokes to focused window.
        #
        # @param [String] keys
        # @raise [ArgumentError]
        def self.send(keys)

            raise ArgumentError, 'Keys parameter must be a String'\
                unless keys.is_a?(String)

            WSH.SendKeys(keys)

        end

        # Ticks or unticks "Force" checkbox in window. This trick fixes clipping.
        #
        # TODO: Simulate a zoom in/out in SketchUp window to force view refresh?
        def self.check_or_uncheck_force

            if @@first_open

                check_or_uncheck_keys = FIRST_CHECK_KEYS
                @@first_open = false

            else

                # Keystrokes to send to window depend on status of "Force" checkbox.
                check_or_uncheck_keys = @@force_checked ? UNCHECK_KEYS : CHECK_KEYS

            end

            # Reverse "Force" checkbox status.
            @@force_checked = !@@force_checked

            open(minimize = true)

            # Since open() is async, we need to wait. TODO: Find a better way.
            # After 1 second:
            UI.start_timer(1) do

                if open?

                    send(check_or_uncheck_keys + CLOSE_KEY)
    
                else

                    # After 2 seconds:
                    UI.start_timer(2) do

                        send(check_or_uncheck_keys + CLOSE_KEY) if open?
        
                    end

                end

            end

            nil

        end

        private_class_method(:send)

    end

end
