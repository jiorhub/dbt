module log;

import std.stdio: writeln;

enum LogLevel {
    DEBUG,
    INFO,
    WARNING,
    ERROR
}

class Logger {
    private {
        static Logger _instance;
        LogLevel _level = LogLevel.WARNING;
        this() {}
    }

    static Logger getLogger() {
        if(_instance is null) {
            _instance = new Logger();
        }
        return _instance;
    }

    void setLogLevel(LogLevel level) {
        _level = level;
    }

    void log(T)(LogLevel level, T message) {
        if(level >= _level) {
            writeln(level, ": ", message);
        }
    }

    void dbg(T)(T message) {
        log(LogLevel.DEBUG, message);
    }

    void info(T)(T message) {
        log(LogLevel.INFO, message);
    }

    void warn(T)(T message) {
        log(LogLevel.WARNING, message);
    }

    void err(T)(T message) {
        log(LogLevel.ERROR, message);
    }
}
