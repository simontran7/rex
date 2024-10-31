#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <errno.h>

typedef enum {
    SUCCESS = 0,
    INVALID_COMMAND = -1,
    INVALID_FILE_EXTENSION = -2,
    INCORRECT_USAGE = -3,
    FILE_OPEN_ERROR = -4,
    MEMORY_ALLOCATION_ERROR = -5,
    FILE_READ_ERROR = -6
} CLIError;

void help(void);
void version(void);
CLIError compile(const char *file_path);

int main(int argc, char *argv[]) 
{
    if (argc == 1) {
        help();
        return SUCCESS;
    } else if (argc == 2) {
        if (strcmp(argv[1], "version") == 0) {
            version();
            return SUCCESS;
        } else if (strcmp(argv[1], "help") == 0) {
            help();
            return SUCCESS;
        } else {
            fputs("CLI Error: Invalid Command\n", stderr);
            return INVALID_COMMAND;
        }
    } else if (argc == 3) {
        const char *command = argv[1];
        const char *file_path = argv[2];

        if (strcmp(command, "build") != 0) {
            fputs("CLI Error: Invalid Command\n", stderr);
            return INVALID_COMMAND;
        }

        uint64_t file_path_length = strlen(file_path);
        if (file_path_length < 4 || strcmp(file_path + file_path_length - 4, ".rex") != 0) {
            fputs("CLI Error: Invalid File Extension\n", stderr);
            return INVALID_FILE_EXTENSION;
        }

        CLIError result = compile(file_path);
        if (result != SUCCESS) {
            fputs("CLI Error: Compilation Failed\n", stderr);
            return result;
        }

        return SUCCESS;
    } else {
        fputs("CLI Error: Incorrect Usage\n", stderr);
        return INCORRECT_USAGE;
    }
}

void help(void) 
{
    const char *message =
        "Rex compiler\n"
        "\n"
        "    Usage: rex [COMMAND] [ARGUMENT]\n"
        "\n"
        "    Commands:\n"
        "        build [file].rex        Compile the current package\n"
        "        help                    Display possible commands\n"
        "        version                 Display compiler version";
    puts(message);
}

void version(void) 
{
    const char *version_message = "dragon 1.0.0";
    puts(version_message);
}

CLIError compile(const char *file_path) 
{
    FILE *file = fopen(file_path, "r");
    if (file == NULL) {
        perror("Error opening file");
        return FILE_OPEN_ERROR;
    }

    fseek(file, 0, SEEK_END);
    int64_t file_size = ftell(file);
    if (file_size == -1L) {
        perror("Error determining file size");
        fclose(file);
        return FILE_READ_ERROR;
    }
    rewind(file);

    char *file_content = (char *) calloc(file_size + 1, sizeof(char));
    if (file_content == NULL) {
        perror("Calloc system call error");
        fclose(file);
        return MEMORY_ALLOCATION_ERROR;
    }

    uint64_t read_size = fread(file_content, 1, file_size, file);
    if (read_size != (uint64_t) file_size) {
        perror("Error reading file");
        free(file_content);
        fclose(file);
        return FILE_READ_ERROR;
    }
    file_content[file_size] = '\0';

    printf("Compiling file: %s\n", file_path);
    printf("File content:\n%s\n", file_content);

    free(file_content);
    fclose(file);

    return SUCCESS;
}
