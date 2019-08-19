//
// Created by Ruan Lei on 20/6/2017.
//

#ifndef XLOGGERR_MDLOGCPP_H
#define XLOGGERR_MDLOGCPP_H


#define __MD__DEFAULT_TAG "CPP_MDLOG"

#ifdef ANDROID
#include "xlogger/xloggerbase.h"
#else
#include "xloggerbase.h"
#endif

    static void __MDComLogV(int level, const char *tag, const char* file, const char* func, int line, const char* fmt, va_list args) {
        struct XLoggerInfo_t info;
        info.level = (TLogLevel)level;
        info.tag = tag;
        info.filename = file;
        info.func_name = func;
        info.line = line;

        gettimeofday(&info.timeval, NULL);
        info.pid = -1;
        info.tid = -1;
        info.maintid = -1;

        xlogger_VPrint(&info, fmt, args);

        //important: do not use like  this:xlogger2((TLogLevel)level, tag, file, func, line, fmt, args);
        //xlogger2((TLogLevel)level, tag, file, func, line).VPrintf(fmt, args);
    }

    static void __MDComLog(int level, const char *tag, const char* file, const char* func, int line, const char* fmt, ...) {
        va_list args;

        va_start(args,fmt);
        __MDComLogV(level, tag, file, func, line,fmt, args);
        va_end(args);
    }

    #define __MDLOG__(LEVEL, LOG_TAG, FMT, ...)  if ((!xlogger_IsEnabledFor(LEVEL))); else __MDComLog(LEVEL, LOG_TAG , __FILE__, __FUNCTION__, __LINE__, FMT,## __VA_ARGS__)

    #define __MDLOGV_TAG(LOG_TAG, FMT, ...)  __MDLOG__(kLevelVerbose, LOG_TAG, FMT, ##__VA_ARGS__)
    #define __MDLOGD_TAG(LOG_TAG, FMT, ...)  __MDLOG__(kLevelDebug, LOG_TAG, FMT, ##__VA_ARGS__)
    #define __MDLOGI_TAG(LOG_TAG, FMT, ...)  __MDLOG__(kLevelInfo, LOG_TAG, FMT, ##__VA_ARGS__)
    #define __MDLOGW_TAG(LOG_TAG, FMT, ...)  __MDLOG__(kLevelWarn, LOG_TAG, FMT, ##__VA_ARGS__)
    #define __MDLOGE_TAG(LOG_TAG, FMT, ...)  __MDLOG__(kLevelError, LOG_TAG, FMT, ##__VA_ARGS__)
    #define __MDLOGEVENT_TAG(LOG_TAG, FMT, ...)  __MDLOG__(kLevelEvent, LOG_TAG, FMT, ##__VA_ARGS__)

    #define __MDLOGV(FMT, ...) __MDLOGV_TAG(__MD__DEFAULT_TAG, FMT, ##__VA_ARGS__)
    #define __MDLOGD(FMT, ...) __MDLOGD_TAG(__MD__DEFAULT_TAG, FMT, ##__VA_ARGS__)
    #define __MDLOGI(FMT, ...) __MDLOGI_TAG(__MD__DEFAULT_TAG, FMT, ##__VA_ARGS__)
    #define __MDLOGW(FMT, ...) __MDLOGW_TAG(__MD__DEFAULT_TAG, FMT, ##__VA_ARGS__)
    #define __MDLOGE(FMT, ...) __MDLOGE_TAG(__MD__DEFAULT_TAG, FMT, ##__VA_ARGS__)

    #define __MDLOGEVENT(value) __MDLOGEVENT_TAG(__MD__DEFAULT_TAG, "%s", value)


#endif //XLOGGERR_MDLOGCPP_H
