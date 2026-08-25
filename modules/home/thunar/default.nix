{ ... }:

{
  xdg.configFile."Thunar/uca.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <actions>
        <action>
            <icon>utilities-terminal</icon>
            <name>Терминал</name>
            <submenu></submenu>
            <unique-id>1700000000-1</unique-id>
            <command>kitty --working-directory %f</command>
            <description>Открывает Kitty в текущей директории</description>
            <range>*</range>
            <patterns>*</patterns>
            <startup-notify/>
            <directories/>
        </action>
        <action>
            <icon>vscode</icon>
            <name>VS Code</name>
            <submenu></submenu>
            <unique-id>1700000000-2</unique-id>
            <command>code %f</command>
            <description>Открывает VS Code в текущей директории</description>
            <range>*</range>
            <patterns>*</patterns>
            <startup-notify/>
            <directories/>
        </action>
    </actions>
  '';
}
