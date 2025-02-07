#include <stdio.h>
#include <string.h>
#include <windows.h>
#include <winreg.h>
#pragma comment(lib,"User32.lib")
#pragma comment(lib,"Advapi32.lib")

const char KEY_CHARSET[] = "BCDFGHJKMPQRTVWXY2346789";

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
    int num, temp;
    unsigned char pidBlock[15];
    char decodedKey[29];
    int isNKey;

    // ���� PID ��ص� 15 ���ֽ�
    for (int i=52;i<=67;i++) {
        pidBlock[i-52]=digitalProductId[i];
    }

    // ����λ����
    isNKey=(pidBlock[14]/8)%2;
    pidBlock[14]=(pidBlock[14]&247)|((isNKey%4>=2?2:0)*4);

    // ��ʼ�� Key �������
    memset(decodedKey,0,sizeof(decodedKey));

    // Base24 ����
    for (int i=28;i>=0;i--) {
        if (((i+1)%6==0)&&1) {
            decodedKey[i]='-';
        } else {
            num=0;
            for (int j=14;j>=0;j--) {
                temp=(num*256)|pidBlock[j];
                pidBlock[j]=temp/24;
                num=temp%24;
                decodedKey[i]=KEY_CHARSET[num];
            }
        }
    }
    // puts(decodedKey);
    // ���� N �汾��Կ
    if (isNKey!=0)
    {
        int nPos=0;
        for (int i=0;i<24;i++) {
            if (decodedKey[0]==KEY_CHARSET[i]) {
                nPos=i;
                break;
            }
        }
        //memmove(decodedKey, decodedKey + 1, 28);
        // puts(decodedKey);
        decodedKey[29]='\0';
        decodedKey[nPos]='N';
    }
    // puts(decodedKey);
    // ��ʽ�����
    snprintf(productKey,30,"%5.5s-%5.5s-%5.5s-%5.5s-%5.5s",
             decodedKey,decodedKey+6,decodedKey+12,decodedKey+18,decodedKey+24);
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
    if(argc==1) {
        puts("Digital Product Id Decoder Console Edition");
        puts("");
        puts("Copyright (C) bingtangxh.");
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
        }

        if(MessageBox(NULL,result,"DPIDDC",MB_ICONINFORMATION + MB_YESNO)==IDYES)
        {
            snprintf(command,41,"echo %s| clip",productKey);
            system(command);
        }
        return 0;
    }
    if(argc==3||argc==2) {
        if(!_stricmp(argv[1],"/venti"))
        {
            if(strlen(argv[2])==328)
            {
                
                strncpy_s(rawInput,329,argv[2],328);
                // �����������õ� _DstSizeInChars �� rawInput �ĳ��ȶ��� 328 
                // ���������Ļ��� strncpy_s �Ὣ rawInput Ū�ɿ��ַ���������ֻ�� 329 ��
                // printf("%s\n%d\n",rawInput,strcmp(rawInput,argv[2]));
            }
            else
            {
                puts("����� DigitalProductId ���ȴ���");
                return 2;
            }
        }
        if(!strncmp(argv[1],"/?",3))
        {
            puts("�� DigitalProductId ע��� DWORD ��ֵ����õ���Ʒ��Կ��");
            puts("");
            puts("Copyright (C) bingtangxh.");
            puts("");
            puts("DPIDDC [ /VENTI digitalproductid | /? ]");
            puts("");
            puts("/VENTI             ��ʾ���н����û������� DigitalProductId��");
            puts("digitalproductid   ע����г���Ϊ 328 �� DWORD ��ֵ��");
            puts("");
            puts("/?                 ��ʾ�˰�����Ϣ��");
            puts("");
            puts("Ҳ����ֱ��˫���������κβ��������б�����ֻ�ܲ�ѯ��ǰϵͳ�Ĳ�Ʒ��Կ��");
            puts("");
            puts("�����Ҫ��һ��������ű����ñ��������������ʹ�ã�");
            puts("");
            puts("FOR /F \"tokens=1-3\" %%A IN ('reg query \"HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\" /v DigitalProductId') DO @IF /I %%A==DigitalProductId DPIDDC /VENTI %%C");
            
            
            return 0;
        }
    } else {
        puts("��������ʹ�� /? �鿴�÷���");
        return 1;
    }
    string2ByteArrayFastest(rawInput,digitalProductId);
    decodePID(digitalProductId, productKey);
    puts(productKey);
    return 0;
}