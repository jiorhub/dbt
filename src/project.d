module project;

import std.stdio: writeln;

struct Property {
    string name;
    string value;
}

struct Target {
    string name;
    string[] depends;

    void execute() {
        writeln("run ", name);
    }
}

class Project {
    //private {
        string _name;
        Property[string] _properties;
        Target[string] _targets;
    //}
}


