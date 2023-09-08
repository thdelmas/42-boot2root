int joder(int param_1)

{
  int iVar1;
  int iVar2;

  if (param_1 < 2) {
    iVar2 = 1;
  }
  else {
    iVar1 = joder(param_1 + -1);
    iVar2 = joder(param_1 + -2);
    iVar2 = iVar2 + iVar1;
  }
  return iVar2;
}

int main()
{
 int ret = 0;
 int i = 0;
 while (ret != 55) {
  ret = joder(i);
  printf("Input: %d\nOutput: %d\n\n", i, ret);
  i++;
 }
}
