
#include "SDL_config.h"

#ifdef __ANDROID__

/* Include the SDL main definition header */
#include "SDL_main.h"
#include <android/log.h>
#include <SDL_version.h>

/*******************************************************************************
                 Functions called by JNI
*******************************************************************************/
#include <jni.h>


// Called before SDL_main() to initialize JNI bindings in SDL library
extern "C" void SDL_Android_Init(JNIEnv* env, jclass cls);


// Library init
extern "C" jint JNI_OnLoad(JavaVM* vm, void* reserved)
{
    return JNI_VERSION_1_6;
}



#if SDL_VERSION_ATLEAST(2,0,0)

// Start up the SDL app
extern "C" void Java_org_libsdl_app_SDLActivity_nativeInit(JNIEnv* env, jclass cls, jobject obj)
{
    // From upstream SDL 2.0 from file: src/main/android/SDL_android_main
    /*
    int i;
    int argc;
    int status;
    */

    // This interface could expand with ABI negotiation, callbacks, etc. 
    SDL_Android_Init(env, cls);

    SDL_SetMainReady();

    // Prepare the arguments. 

/*    int len = (*env)->GetArrayLength(env, array);
    char* argv[1 + len + 1];
    argc = 0;
    // Use the name "app_process" so PHYSFS_platformCalcBaseDir() works.
    //   https://bitbucket.org/MartinFelis/love-android-sdl2/issue/23/release-build-crash-on-start
     
    argv[argc++] = SDL_strdup("app_process");
    for (i = 0; i < len; ++i) {
        const char* utf;
        char* arg = NULL;
        jstring string = (*env)->GetObjectArrayElement(env, array, i);
        if (string) {
            utf = (*env)->GetStringUTFChars(env, string, 0);
            if (utf) {
                arg = SDL_strdup(utf);
                (*env)->ReleaseStringUTFChars(env, string, utf);
            }
            (*env)->DeleteLocalRef(env, string);
        }
        if (!arg) {
            arg = SDL_strdup("");
        }
        argv[argc++] = arg;
    }
    argv[argc] = NULL;*/


    // Run the application. 
    int status;
    int argc = 1;
    char *argv[2];
    argv[0] = strdup("SDL_app");
    argv[1] = NULL;
    __android_log_print(ANDROID_LOG_INFO, "libSDL", "Calling SDL_main(\"%s\")", argv[0]);

    status = SDL_main(argc, argv);

    // Release the arguments. 
/*
    for (i = 0; i < argc; ++i) {
        SDL_free(argv[i]);
    }
*/
    /* This interface could expand with ABI negotiation, callbacks, etc. */
/*
    SDL_Android_Init(env, cls);


    // Run the application code! 
    int status;
    char *argv[2];
    argv[0] = strdup("SDL_app");
    argv[1] = NULL;
    __android_log_print(ANDROID_LOG_INFO, "libSDL", "Calling SDL_main(\"%s\")", argv[0]);
    status = SDL_main(1, argv);
*/

    /* Do not issue an exit or the whole application will terminate instead of just the SDL thread */
    //exit(status);
}

#else

// Start up the SDL app
extern "C" void Java_org_libsdl_app_SDLActivity_nativeInit(JNIEnv* env, jclass cls, jobject obj)
{
    /* This interface could expand with ABI negotiation, calbacks, etc. */
    SDL_Android_Init(env, cls);


    /* Run the application code! */
    int status;
    char *argv[2];
    argv[0] = strdup("SDL_app");
    argv[1] = NULL;
    __android_log_print(ANDROID_LOG_INFO, "libSDL", "Calling SDL_main(\"%s\")", argv[0]);
    status = SDL_main(1, argv);

    /* Do not issue an exit or the whole application will terminate instead of just the SDL thread */
    //exit(status);
}


#endif


#endif /* __ANDROID__ */

/* vi: set ts=4 sw=4 expandtab: */

