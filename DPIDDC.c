#include <stdio.h>
#include <string.h>
#include <windows.h>
#include <winreg.h>
#pragma comment(lib,"User32.lib")
#pragma comment(lib,"Advapi32.lib")

const signed char KEY_CHARSET[] = "BCDFGHJKMPQRTVWXY2346789";

void removeFrom(char *str,char remv)
{
    int i,j=0;
    for(i=0;str[i]!='\0';i++)
    {
        if(str[i]!=remv)
        {
            str[j++]=str[i];
        }
    }
    str[j]='\0';
}

int getHexVal(const char hex)
{
	return hex-((hex>'9')?((hex<'a')?55:87):48);
}

int string2ByteArrayFastest(const char * hex,char * result)
{
	if (strlen(hex)%2==0)
	{
        for (int i=0;i<(int)strlen(hex)/2;i++)
        {
            result[i]=(char) ( (getHexVal(hex[i*2])*16) + getHexVal(hex[(i*2)+1]) );
        }
        return 0;
    }
    else
    {
        puts(hex);
		puts("ʮ�����Ƶ�ԭ�ַ����ĳ��Ȳ���������");
        return -1;
    }
}

void decodePID(const unsigned char *digitalProductId, char *productKey) {
    // int bp=0;
    unsigned char pidBlock[16];
    signed char decodedKey[30];
    // unsigned char digitalProductId2[164];
    // strcpy_s(digitalProductId2,164,digitalProductId);
    int isNKey=(digitalProductId[66]>>3)&1;

    //digitalProductId2[66]=(unsigned char)((digitalProductId2[66]&0xF7)|((isNKey&2)<<2));
    
    // ���� PID ��ص� 15 ���ֽ�
    for (int i=52;i<=67;i++) {
        pidBlock[i-52]=digitalProductId[i];
    }

    // ����λ����  
    pidBlock[14]=(pidBlock[14]&247)|((isNKey%4>=2?2:0)<<2);
    
    // ��ʼ�� Key �������
    memset(decodedKey,0,sizeof(decodedKey));

    // Base24 ����
    for (int i=28;i>=0;i--) {
        if (((i+1)%6==0)&&1) {
            decodedKey[i]='-';
        } else {
            int num=0;
            for (int j=14;j>=0;j--) {
                int temp=(num<<8)|pidBlock[j];
                pidBlock[j]=(unsigned char)(temp/24);
                num=temp%24;
                decodedKey[i]=(signed char)KEY_CHARSET[num];
            }
        }
    }
    if (isNKey!=0)
    {
        int nPos=0;
        for (int i=0;i<24;i++) {
            if (decodedKey[0]==KEY_CHARSET[i]) {
                nPos=i;
                break;
            }
        }
        decodedKey[29]='\0';
        removeFrom(decodedKey,'-');
        memmove(decodedKey, decodedKey + 1, strlen(decodedKey));
        int currentLength=strlen(decodedKey);
        if(nPos>currentLength) nPos=currentLength;
        memmove(decodedKey+nPos+1,decodedKey+nPos,currentLength-nPos+1);
        decodedKey[nPos]='N';
    }
    decodedKey[29]='\0';
    snprintf(productKey,30,"%5.5s-%5.5s-%5.5s-%5.5s-%5.5s",
             decodedKey,decodedKey+5,decodedKey+10,decodedKey+15,decodedKey+20);
}

int main(int argc,char **argv)
{
    
    HKEY hKey;
    DWORD size=ULONG_MAX;
    char buf[UCHAR_MAX];
    char rawInput[329];
    char productKey[30];
    char result[154]="������Ҳ���Դ����������У�ʹ�� /? �鿴�÷���\n��Ĳ�Ʒ��ԿΪ�� ";
    char command[41];
    unsigned char digitalProductId[164];
    long unsigned int lpType=REG_BINARY;
    switch (argc)
    {
    case 1:
        puts("Digital Product Id Decoder Console Edition Bugfixed");
        puts("");
        puts("Copyright (C) bingtangxh.");
        puts("");
        puts("May the Anemo God bless you.");
        puts("");
        long ORet=RegOpenKeyEx(HKEY_LOCAL_MACHINE,"SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion",0,KEY_READ,&hKey);
        if (ORet!=ERROR_SUCCESS)
        {
            printf("��ע���ʧ�ܣ�\n%s\n%s\n","SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion","DigitalProductId");
            return 3;
        }
        else
        {
            long QRet=RegQueryValueEx(hKey,"DigitalProductId",0,&lpType,(BYTE*)buf, &size);
            decodePID(buf, productKey);
            strncat_s(result,154,productKey,29);
            strncat_s(result,154,"\nҪ�������Ƶ���������",35);
            RegCloseKey(hKey);
            if(MessageBox(NULL,result,"DPIDDC",MB_ICONINFORMATION + MB_YESNO)==IDYES)
            {
                snprintf(command,41,"echo %s| clip",productKey);
                system(command);
            }
        return 0;
        }
        break;
    case 2:
        if(!strncmp(argv[1],"/?",3))
        {
            puts("�� DigitalProductId ע��� DWORD ��ֵ����õ���Ʒ��Կ��");
            puts("");
            puts("Copyright (C) bingtangxh.");
            puts("");
            puts("DPIDDC [ /F digitalproductid | /? ]");
            puts("");
            puts("/F                 ��ʾ���н����û������� DigitalProductId��");
            puts("digitalproductid   ע����г���Ϊ 328 �� DWORD ��ֵ��");
            puts("");
            puts("/?                 ��ʾ�˰�����Ϣ��");
            puts("");
            puts("Ҳ����ֱ��˫���������κβ��������б�����ֻ�ܲ�ѯ��ǰϵͳ�Ĳ�Ʒ��Կ��");
            puts("");
            puts("�����Ҫ��һ��������ű����ñ��������������ʹ�ã�");
            puts("");
            puts("FOR /F \"tokens=1-3\" %%A IN ('reg query \"HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\" /v DigitalProductId') DO @IF /I %%A==DigitalProductId DPIDDC /F %%C");

            return 0;
        } else {
            puts("��������ʹ�� /? �鿴�÷���");
            return 1;
        }
        break;
    case 3:
        if(!_stricmp(argv[1],"/F"))
        {
            if(strlen(argv[2])==328)
            {
                strncpy_s(rawInput,329,argv[2],328);
                // �����������õ� _DstSizeInChars �� rawInput �ĳ��ȶ��� 328 
                // ���������Ļ��� strncpy_s �Ὣ rawInput Ū�ɿ��ַ���������ֻ�� 329 ��
                // printf("%s\n%d\n",rawInput,strcmp(rawInput,argv[2]));
                string2ByteArrayFastest(rawInput,digitalProductId);
                decodePID(digitalProductId, productKey);
                puts(productKey);
                return 0;
            }
            else
            {
                puts("����� DigitalProductId ���ȴ���Ӧ���� 328 ��");
                return 2;
            }
        } else {
            puts("��������ʹ�� /? �鿴�÷���");
            return 1;
        }
        break;
    default:
        puts("������������ʹ�� /? �鿴�÷���");
        return 1;
    }
    return 0;
}