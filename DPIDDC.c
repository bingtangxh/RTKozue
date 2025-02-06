#include <stdio.h>
#include <string.h>
#include <windows.h>
#pragma comment(lib,"User32.lib")

const char KEY_CHARSET[] = "BCDFGHJKMPQRTVWXY2346789";

int GetHexVal(const char hex)
{
	return hex - ((hex < ':') ? 48 : ((hex < 'a') ? 55 : 87));
}

int StringToByteArrayFastest(const char * hex,char * result)
{
	if (strlen(hex) % 2 == 1)
	{
		puts("The binary key cannot have an odd number of digits");
        return -1;
	}
	// byte[] array = new byte[hex.Length >> 1];
	for (int i = 0; i < (int) strlen(hex) >> 1; i++)
	{
		result[i] = (char)((GetHexVal(hex[i << 1]) << 4) + GetHexVal(hex[(i << 1) + 1]));
	}
	return 0;
}

void decodePID(const unsigned char *digitalProductId, char *productKey) {
    int keyStart = 52;
    int keyEnd = keyStart + 15;
    int num, temp;
    unsigned char pidBlock[15];
    char decodedKey[29];

    // 复制 PID 相关的 15 个字节
    for (int i = keyStart; i <= keyEnd; i++) {
        pidBlock[i - keyStart] = digitalProductId[i];
    }

    // 特殊位操作
    int isNKey = (pidBlock[14] >> 3) & 1;
    pidBlock[14] = (pidBlock[14] & 0xF7) | ((isNKey & 2) << 2);

    // 初始化 Key 结果数组
    memset(decodedKey, 0, sizeof(decodedKey));

    // Base24 解码
    for (int i = 28; i >= 0; i--) {
        if ( ( (i + 1) % 6 == 0 ) && 1 ) {
            decodedKey[i] = '-';
        } else {
            num = 0;
            for (int j = 14; j >= 0; j--) {
                temp = (num << 8) | pidBlock[j];
                pidBlock[j] = temp / 24;
                num = temp % 24;
                decodedKey[i] = KEY_CHARSET[num];
            }
            
        }
    }
    // puts(decodedKey);
    // 处理 N 版本密钥
    if (isNKey) {
        int nPos = 0;
        for (int i = 0; i < 24; i++) {
            if (decodedKey[0] == KEY_CHARSET[i]) {
                nPos = i;
                break;
            }
        }
        //memmove(decodedKey, decodedKey + 1, 28);
        // puts(decodedKey);
        decodedKey[29] = '\0';
        decodedKey[nPos] = 'N';
    }
    // puts(decodedKey);
    // 格式化输出
    snprintf(productKey, 30, "%5.5s-%5.5s-%5.5s-%5.5s-%5.5s",
             decodedKey, decodedKey + 6, decodedKey + 12, decodedKey + 18, decodedKey + 24 );
}

int main(int argc,char **argv)
{
    char rawInput[329];
    unsigned char digitalProductId[164];
    char productKey[30];
    if(argc==1) {
        MessageBox(NULL,"本程序只能从命令行运行，使用 /? 查看用法。","DPIDDC",MB_ICONINFORMATION + MB_OK);
        return 1;
    }
    if(argc==3 || argc==2) {
        if(!_stricmp(argv[1],"/venti"))
        {
            if(strlen(argv[2])==328)
            {
                
                strncpy_s(rawInput,329,argv[2],328);
                // 本来这里设置的 _DstSizeInChars 和 rawInput 的长度都是 328 
                // 但是这样的话， strncpy_s 会将 rawInput 弄成空字符串，所以只好 329 了
                // printf("%s\n%d\n",rawInput,strcmp(rawInput,argv[2]));
            }
            else
            {
                puts("输入的 DigitalProductId 长度错误");
                return 2;
            }
        }
        if(!strncmp(argv[1],"/?",3))
        {
            puts("将 DigitalProductId 注册表 DWORD 数值解码得到产品密钥。");
            puts("");
            puts("DPIDDC [ /VENTI digitalproductid | /? ]");
            puts("");
            puts("/VENTI             表示进行解码。");
            puts("digitalproductid   注册表中长度为 328 的 DWORD 数值。");
            puts("");
            puts("/?                 显示此帮助信息。");
            puts("");
            puts("无法直接双击（不带任何参数）运行本程序。");
            puts("");
            puts("如果想要从一个批处理脚本调用本程序，你可以这样使用：");
            puts("");
            puts("FOR /F \"tokens=1-3\" %%A IN ('reg query \"HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\" /v DigitalProductId') DO @IF /I %%A==DigitalProductId DPIDDC /VENTI %%C");
            
            
            return 0;
        }
    } else {
        puts("参数错误，使用 /? 查看用法。");
        return 1;
    }
    StringToByteArrayFastest(rawInput,digitalProductId);
    decodePID(digitalProductId, productKey);
    //printf("Decoded Product Key: %s\n", productKey);
    puts(productKey);
    return 0;
}