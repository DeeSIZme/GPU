/*******************************************************************************
 *
 * This code is taken from Intel Monitor Program default lib
 *
 ******************************************************************************/

#ifdef _JTAG_UART_BASE

#include <stddef.h>

void _outbyte(const char c){
  while( (__builtin_ldwio( (void*) (_JTAG_UART_BASE+4) ) & 0xffff0000) == 0 ) ;
  __builtin_stwio( (void*) (_JTAG_UART_BASE), c ) ;
}

size_t write( int fd, const void* buf, const size_t size ) {
  const char* cbuf = (const char*) buf ;
  for( int i = 0 ; i < size ; i++ ) {
    _outbyte( *cbuf++ ) ;
  }

  return size;
}

size_t read( int fd, void* buf, const size_t size ) {
  int data ;
  char* cbuf = (char*) buf ;

  do {
    data = __builtin_ldwio( (void*) (_JTAG_UART_BASE) ) ;
  } while( (data & (1 << 15)) == 0 ) ;

  int charsAvailable = (data >> 16) + 1 ;
  int charsToRead = size < charsAvailable ? size : charsAvailable ;

  for( int i = 0 ; i < charsToRead ; i++ ) {
    *cbuf++ = (char) (data & 0xff) ;
    data = __builtin_ldwio( (void*) (_JTAG_UART_BASE) ) ;
  }

  return charsToRead ;
}

#endif
