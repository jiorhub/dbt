module app;

import std.getopt: getopt;
import std.path: buildPath, isAbsolute;
import std.file: getcwd, exists, readText;
import std.algorithm: startsWith;
import std.json;

import log;
import tasks;
import project;

import std.stdio: writeln;

Project parseConfigToProject(string fileName) {
    Project project = new Project();
    JSONValue json = parseJSON(readText(fileName));

    project._name = json["title"].str;

    foreach(key, val; json["properties"].object) {
        project._properties[key] = Property(key, val.str);
    }

    foreach(name, data; json["targets"].object) {
        auto target = Target(name);
        foreach(attr, value; data.object) {
            switch(attr) {
                case "depends": {
                    foreach(name; value.array) {
                        target.depends ~= name.str;
                    }
                    break;
                }
                default: break;
            }
        }
        project._targets[name] = target;
    }

    return project;
}


int main(string[] args) {
    Logger log = Logger.getLogger();
    log.setLogLevel(LogLevel.DEBUG);
    string fileName = "build.json";

    string[] targets;
    Task[string] tasks;
    tasks["mkdir"] = new MKDirTask();
    //tasks["mkdir"](["dir": "src"]);

    try {
        getopt(args,
            "file|f",
            &fileName
        );
    } catch (Exception e) {
        //nothing
    }

    if(!fileName.isAbsolute()) {
        fileName = buildPath(getcwd(), fileName);
    }

    if(!fileName.exists()) {
        log.err("Not found buildfile: " ~ fileName);
        return 1;
    }

    Project project = parseConfigToProject(fileName);

    bool isSkip = false;
    foreach(arg; args[1..$]) {
        if(arg.startsWith("-")) {
            isSkip = true;
            continue;
        }

        if(isSkip) {
            isSkip = false;
            continue;
        }

        if(arg in project._targets) {
            auto target = project._targets[arg];
            foreach(dep_name; target.depends) {
                project._targets[dep_name].execute();
            }
            target.execute();
        }
    }



    return 0;
}

