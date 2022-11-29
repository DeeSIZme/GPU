/*
   This code is taken from newlib/libgloss
   Source available here:
   https://www.intel.com/content/www/us/en/support/programmable/support-resources/devices/ips-nios2-ide-tutorial.html

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place - Suite 330,
   Boston, MA 02111-1307, USA.
*/

#include <string.h>

extern char __bss_start;
extern char _end;

extern int main (int, char **, char **);


void _zero_bss (void *base, int c, size_t count)
{
  memset (base, c, count);
}

void __fake_init () { /* Do nothing */ }
void _init () __attribute__ ((weak, alias ("__fake_init")));

void exit(int);

void __start_2 (void)
{
  _zero_bss (&__bss_start, 0, &_end - &__bss_start);

  _init ();

  exit (main (0, 0, 0));
}

void __fake_fini () { /* Do nothing */ }
void _fini () __attribute__ ((weak, alias ("__fake_fini")));

void _exit (int exit_code)
{
  _fini ();

  /* exit code in r2, infinite loop */
  __asm__ ( "mov\tr2, %0\n" : : "r" (exit_code));
  for(;;);
}
