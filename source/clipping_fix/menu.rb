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
require 'clipping_fix/camera_window'

# Clipping Fix plugin namespace.
module ClippingFix

  # Connects this plugin menu to SketchUp user interface.
  module Menu

    # Adds menu.
    def self.add

      command = UI::Command.new(NAME) { CameraWindow.check_or_uncheck_force }
      
      command.status_bar_text = TRANSLATE['Toggle between near and far modes.']

      UI.menu('Camera').add_item(command)

    end

  end

end
