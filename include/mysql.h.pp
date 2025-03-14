typedef char my_bool;
typedef int my_socket;
enum enum_server_command
{
  COM_SLEEP, COM_QUIT, COM_INIT_DB, COM_QUERY, COM_FIELD_LIST,
  COM_CREATE_DB, COM_DROP_DB, COM_REFRESH, COM_SHUTDOWN, COM_STATISTICS,
  COM_PROCESS_INFO, COM_CONNECT, COM_PROCESS_KILL, COM_DEBUG, COM_PING,
  COM_TIME, COM_DELAYED_INSERT, COM_CHANGE_USER, COM_BINLOG_DUMP,
  COM_TABLE_DUMP, COM_CONNECT_OUT, COM_REGISTER_SLAVE,
  COM_STMT_PREPARE, COM_STMT_EXECUTE, COM_STMT_SEND_LONG_DATA, COM_STMT_CLOSE,
  COM_STMT_RESET, COM_SET_OPTION, COM_STMT_FETCH, COM_DAEMON,
  COM_UNIMPLEMENTED,
  COM_RESET_CONNECTION,
  COM_MDB_GAP_BEG,
  COM_MDB_GAP_END=249,
  COM_STMT_BULK_EXECUTE=250,
  COM_SLAVE_WORKER=251,
  COM_SLAVE_IO=252,
  COM_SLAVE_SQL=253,
  COM_MULTI=254,
  COM_END=255
};
enum enum_indicator_type
{
  STMT_INDICATOR_NONE= 0,
  STMT_INDICATOR_NULL,
  STMT_INDICATOR_DEFAULT,
  STMT_INDICATOR_IGNORE
};
struct st_vio;
typedef struct st_vio Vio;
typedef struct st_net {
  Vio *vio;
  unsigned char *buff,*buff_end,*write_pos,*read_pos;
  my_socket fd;
  unsigned long remain_in_buf,length, buf_length, where_b;
  unsigned long max_packet,max_packet_size;
  unsigned int pkt_nr,compress_pkt_nr;
  unsigned int write_timeout, read_timeout, retry_count;
  int fcntl;
  unsigned int *return_status;
  unsigned char reading_or_writing;
  char save_char;
  char net_skip_rest_factor;
  my_bool thread_specific_malloc;
  unsigned char compress;
  my_bool unused3;
  void *thd;
  unsigned int last_errno;
  unsigned char error;
  my_bool unused4;
  my_bool unused5;
  char last_error[512];
  char sqlstate[5 +1];
  void *extension;
} NET;
enum enum_field_types { MYSQL_TYPE_DECIMAL, MYSQL_TYPE_TINY,
   MYSQL_TYPE_SHORT, MYSQL_TYPE_LONG,
   MYSQL_TYPE_FLOAT, MYSQL_TYPE_DOUBLE,
   MYSQL_TYPE_NULL, MYSQL_TYPE_TIMESTAMP,
   MYSQL_TYPE_LONGLONG,MYSQL_TYPE_INT24,
   MYSQL_TYPE_DATE, MYSQL_TYPE_TIME,
   MYSQL_TYPE_DATETIME, MYSQL_TYPE_YEAR,
   MYSQL_TYPE_NEWDATE, MYSQL_TYPE_VARCHAR,
   MYSQL_TYPE_BIT,
                        MYSQL_TYPE_TIMESTAMP2,
                        MYSQL_TYPE_DATETIME2,
                        MYSQL_TYPE_TIME2,
                        MYSQL_TYPE_BLOB_COMPRESSED= 140,
                        MYSQL_TYPE_VARCHAR_COMPRESSED= 141,
                        MYSQL_TYPE_NEWDECIMAL=246,
   MYSQL_TYPE_ENUM=247,
   MYSQL_TYPE_SET=248,
   MYSQL_TYPE_TINY_BLOB=249,
   MYSQL_TYPE_MEDIUM_BLOB=250,
   MYSQL_TYPE_LONG_BLOB=251,
   MYSQL_TYPE_BLOB=252,
   MYSQL_TYPE_VAR_STRING=253,
   MYSQL_TYPE_STRING=254,
   MYSQL_TYPE_GEOMETRY=255
};
enum mysql_enum_shutdown_level {
  SHUTDOWN_DEFAULT = 0,
  SHUTDOWN_WAIT_CONNECTIONS= (unsigned char)(1 << 0),
  SHUTDOWN_WAIT_TRANSACTIONS= (unsigned char)(1 << 1),
  SHUTDOWN_WAIT_UPDATES= (unsigned char)(1 << 3),
  SHUTDOWN_WAIT_ALL_BUFFERS= ((unsigned char)(1 << 3) << 1),
  SHUTDOWN_WAIT_CRITICAL_BUFFERS= ((unsigned char)(1 << 3) << 1) + 1
};
enum enum_cursor_type
{
  CURSOR_TYPE_NO_CURSOR= 0,
  CURSOR_TYPE_READ_ONLY= 1,
  CURSOR_TYPE_FOR_UPDATE= 2,
  CURSOR_TYPE_SCROLLABLE= 4
};
enum enum_mysql_set_option
{
  MYSQL_OPTION_MULTI_STATEMENTS_ON,
  MYSQL_OPTION_MULTI_STATEMENTS_OFF
};
enum enum_session_state_type
{
  SESSION_TRACK_SYSTEM_VARIABLES,
  SESSION_TRACK_SCHEMA,
  SESSION_TRACK_STATE_CHANGE,
  SESSION_TRACK_GTIDS,
  SESSION_TRACK_TRANSACTION_CHARACTERISTICS,
  SESSION_TRACK_TRANSACTION_STATE,
  SESSION_TRACK_always_at_the_end
};
my_bool my_net_init(NET *net, Vio* vio, void *thd, unsigned int my_flags);
void my_net_local_init(NET *net);
void net_end(NET *net);
void net_clear(NET *net, my_bool clear_buffer);
my_bool net_realloc(NET *net, size_t length);
my_bool net_flush(NET *net);
my_bool my_net_write(NET *net,const unsigned char *packet, size_t len);
my_bool net_write_command(NET *net,unsigned char command,
     const unsigned char *header, size_t head_len,
     const unsigned char *packet, size_t len);
int net_real_write(NET *net,const unsigned char *packet, size_t len);
unsigned long my_net_read_packet(NET *net, my_bool read_from_server);
unsigned long my_net_read_packet_reallen(NET *net, my_bool read_from_server,
                                         unsigned long* reallen);
struct sockaddr;
int my_connect(my_socket s, const struct sockaddr *name, unsigned int namelen,
        unsigned int timeout);
struct my_rnd_struct;
enum Item_result
{
  STRING_RESULT=0, REAL_RESULT, INT_RESULT, ROW_RESULT, DECIMAL_RESULT,
  TIME_RESULT
};
typedef struct st_udf_args
{
  unsigned int arg_count;
  enum Item_result *arg_type;
  char **args;
  unsigned long *lengths;
  char *maybe_null;
  const char **attributes;
  unsigned long *attribute_lengths;
  void *extension;
} UDF_ARGS;
typedef struct st_udf_init
{
  my_bool maybe_null;
  unsigned int decimals;
  unsigned long max_length;
  char *ptr;
  my_bool const_item;
  void *extension;
} UDF_INIT;
void create_random_string(char *to, unsigned int length,
                          struct my_rnd_struct *rand_st);
void hash_password(unsigned long *to, const char *password, unsigned int password_len);
void make_scrambled_password_323(char *to, const char *password);
void scramble_323(char *to, const char *message, const char *password);
my_bool check_scramble_323(const unsigned char *reply, const char *message,
                           unsigned long *salt);
void get_salt_from_password_323(unsigned long *res, const char *password);
void make_scrambled_password(char *to, const char *password);
void scramble(char *to, const char *message, const char *password);
my_bool check_scramble(const unsigned char *reply, const char *message,
                       const unsigned char *hash_stage2);
void get_salt_from_password(unsigned char *res, const char *password);
char *octet2hex(char *to, const char *str, size_t len);
char *get_tty_password(const char *opt_message);
void get_tty_password_buff(const char *opt_message, char *to, size_t length);
const char *mysql_errno_to_sqlstate(unsigned int mysql_errno);
my_bool my_thread_init(void);
void my_thread_end(void);
typedef long my_time_t;
enum enum_mysql_timestamp_type
{
  MYSQL_TIMESTAMP_NONE= -2, MYSQL_TIMESTAMP_ERROR= -1,
  MYSQL_TIMESTAMP_DATE= 0, MYSQL_TIMESTAMP_DATETIME= 1, MYSQL_TIMESTAMP_TIME= 2
};
typedef struct st_mysql_time
{
  unsigned int year, month, day, hour, minute, second;
  unsigned long second_part;
  my_bool neg;
  enum enum_mysql_timestamp_type time_type;
} MYSQL_TIME;
typedef struct st_list {
  struct st_list *prev,*next;
  void *data;
} LIST;
typedef int (*list_walk_action)(void *,void *);
extern LIST *list_add(LIST *root,LIST *element);
extern LIST *list_delete(LIST *root,LIST *element);
extern LIST *list_cons(void *data,LIST *root);
extern LIST *list_reverse(LIST *root);
extern void list_free(LIST *root,unsigned int free_data);
extern unsigned int list_length(LIST *);
extern int list_walk(LIST *,list_walk_action action,unsigned char * argument);
extern unsigned int mariadb_deinitialize_ssl;
extern unsigned int mysql_port;
extern char *mysql_unix_port;
typedef struct st_mysql_field {
  char *name;
  char *org_name;
  char *table;
  char *org_table;
  char *db;
  char *catalog;
  char *def;
  unsigned long length;
  unsigned long max_length;
  unsigned int name_length;
  unsigned int org_name_length;
  unsigned int table_length;
  unsigned int org_table_length;
  unsigned int db_length;
  unsigned int catalog_length;
  unsigned int def_length;
  unsigned int flags;
  unsigned int decimals;
  unsigned int charsetnr;
  enum enum_field_types type;
  void *extension;
} MYSQL_FIELD;
typedef char **MYSQL_ROW;
typedef unsigned int MYSQL_FIELD_OFFSET;
typedef unsigned long long my_ulonglong;
typedef struct st_used_mem
{
  struct st_used_mem *next;
  size_t left;
  size_t size;
} USED_MEM;
typedef struct st_mem_root
{
  USED_MEM *free;
  USED_MEM *used;
  USED_MEM *pre_alloc;
  size_t min_malloc;
  size_t block_size;
  size_t total_alloc;
  unsigned int block_num;
  unsigned int first_block_usage;
  void (*error_handler)(void);
  const char *name;
} MEM_ROOT;
typedef struct st_typelib {
  unsigned int count;
  const char *name;
  const char **type_names;
  unsigned int *type_lengths;
} TYPELIB;
extern my_ulonglong find_typeset(char *x, TYPELIB *typelib,int *error_position);
extern int find_type_with_warning(const char *x, TYPELIB *typelib,
                                  const char *option);
extern int find_type(const char *x, const TYPELIB *typelib, unsigned int flags);
extern void make_type(char *to,unsigned int nr,TYPELIB *typelib);
extern const char *get_type(TYPELIB *typelib,unsigned int nr);
extern TYPELIB *copy_typelib(MEM_ROOT *root, const TYPELIB *from);
extern TYPELIB sql_protocol_typelib;
my_ulonglong find_set_from_flags(const TYPELIB *lib, unsigned int default_name,
                              my_ulonglong cur_set, my_ulonglong default_set,
                              const char *str, unsigned int length,
                              char **err_pos, unsigned int *err_len);
typedef struct st_mysql_rows {
  struct st_mysql_rows *next;
  MYSQL_ROW data;
  unsigned long length;
} MYSQL_ROWS;
typedef MYSQL_ROWS *MYSQL_ROW_OFFSET;
typedef struct embedded_query_result EMBEDDED_QUERY_RESULT;
typedef struct st_mysql_data {
  MYSQL_ROWS *data;
  struct embedded_query_result *embedded_info;
  MEM_ROOT alloc;
  my_ulonglong rows;
  unsigned int fields;
  void *extension;
} MYSQL_DATA;
enum mysql_option
{
  MYSQL_OPT_CONNECT_TIMEOUT, MYSQL_OPT_COMPRESS, MYSQL_OPT_NAMED_PIPE,
  MYSQL_INIT_COMMAND, MYSQL_READ_DEFAULT_FILE, MYSQL_READ_DEFAULT_GROUP,
  MYSQL_SET_CHARSET_DIR, MYSQL_SET_CHARSET_NAME, MYSQL_OPT_LOCAL_INFILE,
  MYSQL_OPT_PROTOCOL, MYSQL_SHARED_MEMORY_BASE_NAME, MYSQL_OPT_READ_TIMEOUT,
  MYSQL_OPT_WRITE_TIMEOUT, MYSQL_OPT_USE_RESULT,
  MYSQL_OPT_USE_REMOTE_CONNECTION, MYSQL_OPT_USE_EMBEDDED_CONNECTION,
  MYSQL_OPT_GUESS_CONNECTION, MYSQL_SET_CLIENT_IP, MYSQL_SECURE_AUTH,
  MYSQL_REPORT_DATA_TRUNCATION, MYSQL_OPT_RECONNECT,
  MYSQL_OPT_SSL_VERIFY_SERVER_CERT, MYSQL_PLUGIN_DIR, MYSQL_DEFAULT_AUTH,
  MYSQL_OPT_BIND,
  MYSQL_OPT_SSL_KEY, MYSQL_OPT_SSL_CERT,
  MYSQL_OPT_SSL_CA, MYSQL_OPT_SSL_CAPATH, MYSQL_OPT_SSL_CIPHER,
  MYSQL_OPT_SSL_CRL, MYSQL_OPT_SSL_CRLPATH,
  MYSQL_OPT_CONNECT_ATTR_RESET, MYSQL_OPT_CONNECT_ATTR_ADD,
  MYSQL_OPT_CONNECT_ATTR_DELETE,
  MYSQL_SERVER_PUBLIC_KEY,
  MYSQL_ENABLE_CLEARTEXT_PLUGIN,
  MYSQL_OPT_CAN_HANDLE_EXPIRED_PASSWORDS,
  MYSQL_PROGRESS_CALLBACK=5999,
  MYSQL_OPT_NONBLOCK,
  MYSQL_OPT_USE_THREAD_SPECIFIC_MEMORY
};
struct st_mysql_options_extention;
struct st_mysql_options {
  unsigned int connect_timeout, read_timeout, write_timeout;
  unsigned int port, protocol;
  unsigned long client_flag;
  char *host,*user,*password,*unix_socket,*db;
  struct st_dynamic_array *init_commands;
  char *my_cnf_file,*my_cnf_group, *charset_dir, *charset_name;
  char *ssl_key;
  char *ssl_cert;
  char *ssl_ca;
  char *ssl_capath;
  char *ssl_cipher;
  char *shared_memory_base_name;
  unsigned long max_allowed_packet;
  my_bool use_ssl;
  my_bool compress,named_pipe;
  my_bool use_thread_specific_memory;
  my_bool unused2;
  my_bool unused3;
  my_bool unused4;
  enum mysql_option methods_to_use;
  char *client_ip;
  my_bool secure_auth;
  my_bool report_data_truncation;
  int (*local_infile_init)(void **, const char *, void *);
  int (*local_infile_read)(void *, char *, unsigned int);
  void (*local_infile_end)(void *);
  int (*local_infile_error)(void *, char *, unsigned int);
  void *local_infile_userdata;
  struct st_mysql_options_extention *extension;
};
enum mysql_status
{
  MYSQL_STATUS_READY, MYSQL_STATUS_GET_RESULT, MYSQL_STATUS_USE_RESULT,
  MYSQL_STATUS_STATEMENT_GET_RESULT
};
enum mysql_protocol_type
{
  MYSQL_PROTOCOL_DEFAULT, MYSQL_PROTOCOL_TCP, MYSQL_PROTOCOL_SOCKET,
  MYSQL_PROTOCOL_PIPE, MYSQL_PROTOCOL_MEMORY
};
typedef struct character_set
{
  unsigned int number;
  unsigned int state;
  const char *csname;
  const char *name;
  const char *comment;
  const char *dir;
  unsigned int mbminlen;
  unsigned int mbmaxlen;
} MY_CHARSET_INFO;
struct st_mysql_methods;
struct st_mysql_stmt;
typedef struct st_mysql
{
  NET net;
  unsigned char *connector_fd;
  char *host,*user,*passwd,*unix_socket,*server_version,*host_info;
  char *info, *db;
  const struct charset_info_st *charset;
  MYSQL_FIELD *fields;
  MEM_ROOT field_alloc;
  my_ulonglong affected_rows;
  my_ulonglong insert_id;
  my_ulonglong extra_info;
  unsigned long thread_id;
  unsigned long packet_length;
  unsigned int port;
  unsigned long client_flag,server_capabilities;
  unsigned int protocol_version;
  unsigned int field_count;
  unsigned int server_status;
  unsigned int server_language;
  unsigned int warning_count;
  struct st_mysql_options options;
  enum mysql_status status;
  my_bool free_me;
  my_bool reconnect;
  char scramble[20 +1];
  my_bool auto_local_infile;
  void *unused2, *unused3, *unused4, *unused5;
  LIST *stmts;
  const struct st_mysql_methods *methods;
  void *thd;
  my_bool *unbuffered_fetch_owner;
  char *info_buffer;
  void *extension;
} MYSQL;
typedef struct st_mysql_res {
  my_ulonglong row_count;
  MYSQL_FIELD *fields;
  MYSQL_DATA *data;
  MYSQL_ROWS *data_cursor;
  unsigned long *lengths;
  MYSQL *handle;
  const struct st_mysql_methods *methods;
  MYSQL_ROW row;
  MYSQL_ROW current_row;
  MEM_ROOT field_alloc;
  unsigned int field_count, current_field;
  my_bool eof;
  my_bool unbuffered_fetch_cancelled;
  void *extension;
} MYSQL_RES;
typedef struct st_mysql_parameters
{
  unsigned long *p_max_allowed_packet;
  unsigned long *p_net_buffer_length;
  void *extension;
} MYSQL_PARAMETERS;
int mysql_server_init(int argc, char **argv, char **groups);
void mysql_server_end(void);
MYSQL_PARAMETERS * mysql_get_parameters(void);
my_bool mysql_thread_init(void);
void mysql_thread_end(void);
my_ulonglong mysql_num_rows(MYSQL_RES *res);
unsigned int mysql_num_fields(MYSQL_RES *res);
my_bool mysql_eof(MYSQL_RES *res);
MYSQL_FIELD * mysql_fetch_field_direct(MYSQL_RES *res,
           unsigned int fieldnr);
MYSQL_FIELD * mysql_fetch_fields(MYSQL_RES *res);
MYSQL_ROW_OFFSET mysql_row_tell(MYSQL_RES *res);
MYSQL_FIELD_OFFSET mysql_field_tell(MYSQL_RES *res);
unsigned int mysql_field_count(MYSQL *mysql);
my_ulonglong mysql_affected_rows(MYSQL *mysql);
my_ulonglong mysql_insert_id(MYSQL *mysql);
unsigned int mysql_errno(MYSQL *mysql);
const char * mysql_error(MYSQL *mysql);
const char * mysql_sqlstate(MYSQL *mysql);
unsigned int mysql_warning_count(MYSQL *mysql);
const char * mysql_info(MYSQL *mysql);
unsigned long mysql_thread_id(MYSQL *mysql);
const char * mysql_character_set_name(MYSQL *mysql);
int mysql_set_character_set(MYSQL *mysql, const char *csname);
int mysql_set_character_set_start(int *ret, MYSQL *mysql,
                                                   const char *csname);
int mysql_set_character_set_cont(int *ret, MYSQL *mysql,
                                                  int status);
MYSQL * mysql_init(MYSQL *mysql);
my_bool mysql_ssl_set(MYSQL *mysql, const char *key,
          const char *cert, const char *ca,
          const char *capath, const char *cipher);
const char * mysql_get_ssl_cipher(MYSQL *mysql);
my_bool mysql_change_user(MYSQL *mysql, const char *user,
       const char *passwd, const char *db);
int mysql_change_user_start(my_bool *ret, MYSQL *mysql,
                                                const char *user,
                                                const char *passwd,
                                                const char *db);
int mysql_change_user_cont(my_bool *ret, MYSQL *mysql,
                                               int status);
MYSQL * mysql_real_connect(MYSQL *mysql, const char *host,
        const char *user,
        const char *passwd,
        const char *db,
        unsigned int port,
        const char *unix_socket,
        unsigned long clientflag);
int mysql_real_connect_start(MYSQL **ret, MYSQL *mysql,
                                                 const char *host,
                                                 const char *user,
                                                 const char *passwd,
                                                 const char *db,
                                                 unsigned int port,
                                                 const char *unix_socket,
                                                 unsigned long clientflag);
int mysql_real_connect_cont(MYSQL **ret, MYSQL *mysql,
                                                int status);
int mysql_select_db(MYSQL *mysql, const char *db);
int mysql_select_db_start(int *ret, MYSQL *mysql,
                                              const char *db);
int mysql_select_db_cont(int *ret, MYSQL *mysql,
                                             int status);
int mysql_query(MYSQL *mysql, const char *q);
int mysql_query_start(int *ret, MYSQL *mysql,
                                          const char *q);
int mysql_query_cont(int *ret, MYSQL *mysql,
                                         int status);
int mysql_send_query(MYSQL *mysql, const char *q,
      unsigned long length);
int mysql_send_query_start(int *ret, MYSQL *mysql,
                                               const char *q,
                                               unsigned long length);
int mysql_send_query_cont(int *ret, MYSQL *mysql,
                                              int status);
int mysql_real_query(MYSQL *mysql, const char *q,
     unsigned long length);
int mysql_real_query_start(int *ret, MYSQL *mysql,
                                               const char *q,
                                               unsigned long length);
int mysql_real_query_cont(int *ret, MYSQL *mysql,
                                              int status);
MYSQL_RES * mysql_store_result(MYSQL *mysql);
int mysql_store_result_start(MYSQL_RES **ret, MYSQL *mysql);
int mysql_store_result_cont(MYSQL_RES **ret, MYSQL *mysql,
                                                int status);
MYSQL_RES * mysql_use_result(MYSQL *mysql);
void mysql_get_character_set_info(MYSQL *mysql,
                           MY_CHARSET_INFO *charset);
void
mysql_set_local_infile_handler(MYSQL *mysql,
                               int (*local_infile_init)(void **, const char *,
                            void *),
                               int (*local_infile_read)(void *, char *,
       unsigned int),
                               void (*local_infile_end)(void *),
                               int (*local_infile_error)(void *, char*,
        unsigned int),
                               void *);
void
mysql_set_local_infile_default(MYSQL *mysql);
int mysql_shutdown(MYSQL *mysql,
                                       enum mysql_enum_shutdown_level
                                       shutdown_level);
int mysql_shutdown_start(int *ret, MYSQL *mysql,
                                             enum mysql_enum_shutdown_level
                                             shutdown_level);
int mysql_shutdown_cont(int *ret, MYSQL *mysql,
                                            int status);
int mysql_dump_debug_info(MYSQL *mysql);
int mysql_dump_debug_info_start(int *ret, MYSQL *mysql);
int mysql_dump_debug_info_cont(int *ret, MYSQL *mysql,
                                                   int status);
int mysql_refresh(MYSQL *mysql,
         unsigned int refresh_options);
int mysql_refresh_start(int *ret, MYSQL *mysql,
                                            unsigned int refresh_options);
int mysql_refresh_cont(int *ret, MYSQL *mysql, int status);
int mysql_kill(MYSQL *mysql,unsigned long pid);
int mysql_kill_start(int *ret, MYSQL *mysql,
                                         unsigned long pid);
int mysql_kill_cont(int *ret, MYSQL *mysql, int status);
int mysql_set_server_option(MYSQL *mysql,
      enum enum_mysql_set_option
      option);
int mysql_set_server_option_start(int *ret, MYSQL *mysql,
                                                      enum enum_mysql_set_option
                                                      option);
int mysql_set_server_option_cont(int *ret, MYSQL *mysql,
                                                     int status);
int mysql_ping(MYSQL *mysql);
int mysql_ping_start(int *ret, MYSQL *mysql);
int mysql_ping_cont(int *ret, MYSQL *mysql, int status);
const char * mysql_stat(MYSQL *mysql);
int mysql_stat_start(const char **ret, MYSQL *mysql);
int mysql_stat_cont(const char **ret, MYSQL *mysql,
                                        int status);
const char * mysql_get_server_info(MYSQL *mysql);
const char * mysql_get_server_name(MYSQL *mysql);
const char * mysql_get_client_info(void);
unsigned long mysql_get_client_version(void);
const char * mysql_get_host_info(MYSQL *mysql);
unsigned long mysql_get_server_version(MYSQL *mysql);
unsigned int mysql_get_proto_info(MYSQL *mysql);
MYSQL_RES * mysql_list_dbs(MYSQL *mysql,const char *wild);
int mysql_list_dbs_start(MYSQL_RES **ret, MYSQL *mysql,
                                             const char *wild);
int mysql_list_dbs_cont(MYSQL_RES **ret, MYSQL *mysql,
                                            int status);
MYSQL_RES * mysql_list_tables(MYSQL *mysql,const char *wild);
int mysql_list_tables_start(MYSQL_RES **ret, MYSQL *mysql,
                                                const char *wild);
int mysql_list_tables_cont(MYSQL_RES **ret, MYSQL *mysql,
                                               int status);
MYSQL_RES * mysql_list_processes(MYSQL *mysql);
int mysql_list_processes_start(MYSQL_RES **ret,
                                                   MYSQL *mysql);
int mysql_list_processes_cont(MYSQL_RES **ret, MYSQL *mysql,
                                                  int status);
int mysql_options(MYSQL *mysql,enum mysql_option option,
          const void *arg);
int mysql_options4(MYSQL *mysql,enum mysql_option option,
                                       const void *arg1, const void *arg2);
void mysql_free_result(MYSQL_RES *result);
int mysql_free_result_start(MYSQL_RES *result);
int mysql_free_result_cont(MYSQL_RES *result, int status);
void mysql_data_seek(MYSQL_RES *result,
     my_ulonglong offset);
MYSQL_ROW_OFFSET mysql_row_seek(MYSQL_RES *result,
      MYSQL_ROW_OFFSET offset);
MYSQL_FIELD_OFFSET mysql_field_seek(MYSQL_RES *result,
        MYSQL_FIELD_OFFSET offset);
MYSQL_ROW mysql_fetch_row(MYSQL_RES *result);
int mysql_fetch_row_start(MYSQL_ROW *ret,
                                              MYSQL_RES *result);
int mysql_fetch_row_cont(MYSQL_ROW *ret, MYSQL_RES *result,
                                             int status);
unsigned long * mysql_fetch_lengths(MYSQL_RES *result);
MYSQL_FIELD * mysql_fetch_field(MYSQL_RES *result);
MYSQL_RES * mysql_list_fields(MYSQL *mysql, const char *table,
       const char *wild);
int mysql_list_fields_start(MYSQL_RES **ret, MYSQL *mysql,
                                                const char *table,
                                                const char *wild);
int mysql_list_fields_cont(MYSQL_RES **ret, MYSQL *mysql,
                                               int status);
unsigned long mysql_escape_string(char *to,const char *from,
         unsigned long from_length);
unsigned long mysql_hex_string(char *to,const char *from,
                                         unsigned long from_length);
unsigned long mysql_real_escape_string(MYSQL *mysql,
            char *to,const char *from,
            unsigned long length);
void mysql_debug(const char *debug);
void myodbc_remove_escape(MYSQL *mysql,char *name);
unsigned int mysql_thread_safe(void);
my_bool mysql_embedded(void);
my_bool mariadb_connection(MYSQL *mysql);
my_bool mysql_read_query_result(MYSQL *mysql);
int mysql_read_query_result_start(my_bool *ret,
                                                      MYSQL *mysql);
int mysql_read_query_result_cont(my_bool *ret,
                                                     MYSQL *mysql, int status);
enum enum_mysql_stmt_state
{
  MYSQL_STMT_INIT_DONE= 1, MYSQL_STMT_PREPARE_DONE, MYSQL_STMT_EXECUTE_DONE,
  MYSQL_STMT_FETCH_DONE
};
typedef struct st_mysql_bind
{
  unsigned long *length;
  my_bool *is_null;
  void *buffer;
  my_bool *error;
  unsigned char *row_ptr;
  void (*store_param_func)(NET *net, struct st_mysql_bind *param);
  void (*fetch_result)(struct st_mysql_bind *, MYSQL_FIELD *,
                       unsigned char **row);
  void (*skip_result)(struct st_mysql_bind *, MYSQL_FIELD *,
        unsigned char **row);
  unsigned long buffer_length;
  unsigned long offset;
  unsigned long length_value;
  unsigned int param_number;
  unsigned int pack_length;
  enum enum_field_types buffer_type;
  my_bool error_value;
  my_bool is_unsigned;
  my_bool long_data_used;
  my_bool is_null_value;
  void *extension;
} MYSQL_BIND;
struct st_mysql_stmt_extension;
typedef struct st_mysql_stmt
{
  MEM_ROOT mem_root;
  LIST list;
  MYSQL *mysql;
  MYSQL_BIND *params;
  MYSQL_BIND *bind;
  MYSQL_FIELD *fields;
  MYSQL_DATA result;
  MYSQL_ROWS *data_cursor;
  int (*read_row_func)(struct st_mysql_stmt *stmt,
                                  unsigned char **row);
  my_ulonglong affected_rows;
  my_ulonglong insert_id;
  unsigned long stmt_id;
  unsigned long flags;
  unsigned long prefetch_rows;
  unsigned int server_status;
  unsigned int last_errno;
  unsigned int param_count;
  unsigned int field_count;
  enum enum_mysql_stmt_state state;
  char last_error[512];
  char sqlstate[5 +1];
  my_bool send_types_to_server;
  my_bool bind_param_done;
  unsigned char bind_result_done;
  my_bool unbuffered_fetch_cancelled;
  my_bool update_max_length;
  struct st_mysql_stmt_extension *extension;
} MYSQL_STMT;
enum enum_stmt_attr_type
{
  STMT_ATTR_UPDATE_MAX_LENGTH,
  STMT_ATTR_CURSOR_TYPE,
  STMT_ATTR_PREFETCH_ROWS
};
MYSQL_STMT * mysql_stmt_init(MYSQL *mysql);
int mysql_stmt_prepare(MYSQL_STMT *stmt, const char *query,
                               unsigned long length);
int mysql_stmt_prepare_start(int *ret, MYSQL_STMT *stmt,
                                     const char *query, unsigned long length);
int mysql_stmt_prepare_cont(int *ret, MYSQL_STMT *stmt, int status);
int mysql_stmt_execute(MYSQL_STMT *stmt);
int mysql_stmt_execute_start(int *ret, MYSQL_STMT *stmt);
int mysql_stmt_execute_cont(int *ret, MYSQL_STMT *stmt, int status);
int mysql_stmt_fetch(MYSQL_STMT *stmt);
int mysql_stmt_fetch_start(int *ret, MYSQL_STMT *stmt);
int mysql_stmt_fetch_cont(int *ret, MYSQL_STMT *stmt, int status);
int mysql_stmt_fetch_column(MYSQL_STMT *stmt, MYSQL_BIND *bind_arg,
                                    unsigned int column,
                                    unsigned long offset);
int mysql_stmt_store_result(MYSQL_STMT *stmt);
int mysql_stmt_store_result_start(int *ret, MYSQL_STMT *stmt);
int mysql_stmt_store_result_cont(int *ret, MYSQL_STMT *stmt,
                                         int status);
unsigned long mysql_stmt_param_count(MYSQL_STMT * stmt);
my_bool mysql_stmt_attr_set(MYSQL_STMT *stmt,
                                    enum enum_stmt_attr_type attr_type,
                                    const void *attr);
my_bool mysql_stmt_attr_get(MYSQL_STMT *stmt,
                                    enum enum_stmt_attr_type attr_type,
                                    void *attr);
my_bool mysql_stmt_bind_param(MYSQL_STMT * stmt, MYSQL_BIND * bnd);
my_bool mysql_stmt_bind_result(MYSQL_STMT * stmt, MYSQL_BIND * bnd);
my_bool mysql_stmt_close(MYSQL_STMT * stmt);
int mysql_stmt_close_start(my_bool *ret, MYSQL_STMT *stmt);
int mysql_stmt_close_cont(my_bool *ret, MYSQL_STMT * stmt, int status);
my_bool mysql_stmt_reset(MYSQL_STMT * stmt);
int mysql_stmt_reset_start(my_bool *ret, MYSQL_STMT * stmt);
int mysql_stmt_reset_cont(my_bool *ret, MYSQL_STMT *stmt, int status);
my_bool mysql_stmt_free_result(MYSQL_STMT *stmt);
int mysql_stmt_free_result_start(my_bool *ret, MYSQL_STMT *stmt);
int mysql_stmt_free_result_cont(my_bool *ret, MYSQL_STMT *stmt,
                                        int status);
my_bool mysql_stmt_send_long_data(MYSQL_STMT *stmt,
                                          unsigned int param_number,
                                          const char *data,
                                          unsigned long length);
int mysql_stmt_send_long_data_start(my_bool *ret, MYSQL_STMT *stmt,
                                            unsigned int param_number,
                                            const char *data,
                                            unsigned long len);
int mysql_stmt_send_long_data_cont(my_bool *ret, MYSQL_STMT *stmt,
                                           int status);
MYSQL_RES * mysql_stmt_result_metadata(MYSQL_STMT *stmt);
MYSQL_RES * mysql_stmt_param_metadata(MYSQL_STMT *stmt);
unsigned int mysql_stmt_errno(MYSQL_STMT * stmt);
const char * mysql_stmt_error(MYSQL_STMT * stmt);
const char * mysql_stmt_sqlstate(MYSQL_STMT * stmt);
MYSQL_ROW_OFFSET mysql_stmt_row_seek(MYSQL_STMT *stmt,
                                             MYSQL_ROW_OFFSET offset);
MYSQL_ROW_OFFSET mysql_stmt_row_tell(MYSQL_STMT *stmt);
void mysql_stmt_data_seek(MYSQL_STMT *stmt, my_ulonglong offset);
my_ulonglong mysql_stmt_num_rows(MYSQL_STMT *stmt);
my_ulonglong mysql_stmt_affected_rows(MYSQL_STMT *stmt);
my_ulonglong mysql_stmt_insert_id(MYSQL_STMT *stmt);
unsigned int mysql_stmt_field_count(MYSQL_STMT *stmt);
my_bool mysql_commit(MYSQL * mysql);
int mysql_commit_start(my_bool *ret, MYSQL * mysql);
int mysql_commit_cont(my_bool *ret, MYSQL * mysql, int status);
my_bool mysql_rollback(MYSQL * mysql);
int mysql_rollback_start(my_bool *ret, MYSQL * mysql);
int mysql_rollback_cont(my_bool *ret, MYSQL * mysql, int status);
my_bool mysql_autocommit(MYSQL * mysql, my_bool auto_mode);
int mysql_autocommit_start(my_bool *ret, MYSQL * mysql,
                                   my_bool auto_mode);
int mysql_autocommit_cont(my_bool *ret, MYSQL * mysql, int status);
my_bool mysql_more_results(MYSQL *mysql);
int mysql_next_result(MYSQL *mysql);
int mysql_next_result_start(int *ret, MYSQL *mysql);
int mysql_next_result_cont(int *ret, MYSQL *mysql, int status);
int mysql_stmt_next_result(MYSQL_STMT *stmt);
int mysql_stmt_next_result_start(int *ret, MYSQL_STMT *stmt);
int mysql_stmt_next_result_cont(int *ret, MYSQL_STMT *stmt, int status);
void mysql_close_slow_part(MYSQL *mysql);
void mysql_close(MYSQL *sock);
int mysql_close_start(MYSQL *sock);
int mysql_close_cont(MYSQL *sock, int status);
my_socket mysql_get_socket(const MYSQL *mysql);
unsigned int mysql_get_timeout_value(const MYSQL *mysql);
unsigned int mysql_get_timeout_value_ms(const MYSQL *mysql);
unsigned long mysql_net_read_packet(MYSQL *mysql);
unsigned long mysql_net_field_length(unsigned char **packet);
