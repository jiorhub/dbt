module tasks;

import log;

abstract class Task {
    Logger log;
    this() {
        log = Logger.getLogger();
    }

    Task opCall(string[string] args);
}

class MKDirTask : Task {
    override
    Task opCall(string[string] args) {
        log.info("mkdir:");
        return this;
    }
}

