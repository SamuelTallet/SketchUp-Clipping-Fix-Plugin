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
require 'extensions'

# Clipping Fix plugin namespace.
module ClippingFix

    VERSION = '1.0.1'

    # Load the translation of this plugin if it's available for the current locale.
    TRANSLATE = LanguageHandler.new('clipping_fix.translation')
    # @see "clipping_fix/Resources/#{Sketchup.get_locale}/clipping_fix.translation"

    NAME = TRANSLATE['Clipping Fix']

    SUPPORTED_LOCALES = [
        'en-US', # English
        'de',    # German
        'es',    # Spanish
        'fr',    # French
        'it',    # Italian
        'ja',    # Japanese
        'ko',    # Korean
        'pl',    # Polish
        'pt-BR', # Brazilian Portuguese
        'ru',    # Russian
        'sv',    # Swedish
        'zh-CN', # Simplified Chinese
        'zh-TW'  # Traditional Chinese
    ]

    # Displays an error related to this plugin.
    #
    # @private
    #
    # @param [String] message
    # @param [String] more More info. Optional.
    #
    # @return [Boolean] false
    def self.error(message, more = '')

        unless more.empty?
            more = ' ' + more
        end

        UI.messagebox(TRANSLATE['Clipping Fix:'] + ' ' + TRANSLATE[message] + more)
        false

    end

    # Is this plugin supported by this system?
    #
    # @return [Boolean]
    def self.supported?

        # Given that "Camera" window seems only available on Windows.
        return error('This plugin works only on Windows platform.')\
            unless Sketchup.platform == :platform_win

        # Given that we can't force "Near" in older "Camera" windows.
        return error('This plugin requires at least SketchUp 2017.')\
            unless Sketchup.version.to_i >= 17

        # Translation is required because code finds window by title.
        return error("Your locale isn't yet supported. Locale:", Sketchup.get_locale)\
            unless SUPPORTED_LOCALES.include?(Sketchup.get_locale)
        
        true

    end

    # Registers then loads this plugin.
    #
    # @private
    #
    # @return [Boolean] true on success...
    def self.register

        extension = SketchupExtension.new(NAME, 'clipping_fix/load.rb')
  
        extension.version     = VERSION
        extension.creator     = 'Samuel Tallet'
        extension.copyright   = "© 2021 #{extension.creator}"
        extension.description = TRANSLATE[
            'This free SketchUp plugin allows you to fix “Camera Clipping Plane” issue in one click.'
        ]

        Sketchup.register_extension(extension, load_at_start = true)

    end

    register if supported?

    private_class_method(:error, :register)

end
