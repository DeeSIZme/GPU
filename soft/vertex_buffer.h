/*
#ifndef VERTEX_BUFFER_H_
#define VERTEX_BUFFER_H_

#include <stdint.h>

typedef struct {
  uint32_t count;

  // aligned on 32 bit
  struct {
    uint16_t d [3];
    uint16_t reserved;
  }* pos;

  // aligned on 32 bit
  struct {
    uint8_t rgb [3];
    uint8_t reserved;
  }* color;

} vertex_array_t;

#define VERTEX_BUFFER_INIT(name, length)                                    \
  coord_t pos_##name[length];                                               \
  color_t color_##name[length];                                             \
  vertex_buffer_t ##name = {                                                \
    .count = length, .pos = pos_##name, .color = color_##name,              \
  }

#endif
*/