#define _CRT_SECURE_NO_DEPRECATE
#include "common.h"

static uint8_t title(void)
{
	printf("**********************************************\n"
	       "**               SUSIIoT demo               **\n"
	       "**********************************************\n");

	printf("0.Exit\n"
		   "1.Capability object\n"
	       "2.Capability string\n"
	       "3.Get data object\n"
	       "4.Get data string\n"
		   "5.Get data object by URI\n"
		   "6.Get data string by URI\n"
	       "7.Get data value\n"
	       "8.Set Data object\n"
	       "9.Set data string\n"
	       "10.Set Data value\n"
		   "11.Enable logger\n"
		   "12.Disable logger\n"
		   "13.Get logger path\n"
		   "14.Get logger status\n"
	       "Enter your choice:");

	return 0;
}

static json_t* getDataJson(uint32_t &id)
{
    int ret = 0;
	json_t *jsonObject = NULL;
	uint32_t type = 0;

	printf("Get Data ID: ");
	ret = SCANF("%d", &id);

	printf("\nType: 1. integer  2. real  3. string\nType: ");
	ret = SCANF("%d", &type);

	switch (type)
	{
		case 1:
			jsonObject = json_integer(0);
			break;
		case 2:
			jsonObject = json_real(0.0);
			break;
		case 3:
			jsonObject = json_string("");
			break;
		default:
			printf("no this type\n");
			break;
	}

    if (ret == 0) {}

	return jsonObject;
}

static json_t* setDataJson(uint32_t &id)
{
    int ret = 0;
	json_t *jsonObject = NULL;
	uint32_t type = 0;
	int setInt = 0;
	double setReal = 0.0;
	char setStr[65536];

	printf("Set Data Id: ");
	ret = SCANF("%d", &id);

	printf("\nType: 1. integer  2. real  3. string\nType: ");
	ret = SCANF("%d", &type);

	printf("\nValue: ");
	switch (type)
	{
		case 1:
			ret = SCANF("%d", &setInt);
			printf("setInt: %d\n", setInt);
			jsonObject = json_integer(setInt);
			break;
		case 2:
			ret = SCANF("%lf", &setReal);
			printf("setReal: %f\n", setReal);
			jsonObject = json_real(setReal);
			break;
		case 3:
			getchar();  // clear scanf input buffer
			ret = SCANF("%[^\n]", setStr);
			printf("setStr: %s\n", setStr);
			jsonObject = json_string((char*)setStr);
			break;
		default:
			printf("no this type\n");
			break;
	}

    if (ret == 0) {}

	return jsonObject;
}

static void testfunction()
{
    int ret = 0;
	const int count = 100000;
	uint32_t id;

	printf("Test SusiIoTGetPFCapability\r\n");
	json_t *susi_iot = json_object();
	for(int i = 0; i < count; i++)
	{
		printf("\r%.2f %%", i * (100 / (float)count));
		if(SusiIoTGetPFCapability(susi_iot) != 0)
		{
			//printf("\nSusiIoTGetPFCapability failed. \n");
		}
	}
	json_object_clear(susi_iot);
	json_decref(susi_iot);
	ret = PAUSE();

	printf("Test SusiIoTGetPFData\r\n");
	json_t *jtmp = json_object();
	for(int i = 0; i < count; i++)
	{
		printf("\r%.2f %%", i * (100 / (float)count));
		if(SusiIoTGetPFData(0, jtmp) != 0)
		{
			//printf("SusiIoTGetPFData failed. \n");
		}
	}
	json_object_clear(jtmp);
	json_decref(jtmp);
	ret = PAUSE();

	printf("Test SusiIoTSetPFData\r\n");
	jtmp = json_object();
	for(int i = 0; i < count; i++)
	{
		printf("\r%.2f %%", i * (100 / (float)count));
		if(SusiIoTGetPFData(0, jtmp) != 0)
		{
			//printf("SusiIoTGetPFData failed. \n");
		}
		if(SusiIoTSetPFData(jtmp) != 0)
		{
			//printf("SusiIoTSetPFData failed. \n");
		}
	}
	json_object_clear(jtmp);
	json_decref(jtmp);
	PAUSE();

	printf("Test SusiIoTGetValue\r\n");
	json_t *jsonGet = getDataJson(id);
	for(int i = 0; i < count; i++)
	{
		printf("\r%.2f %%", i * (100 / (float)count));
		if(SusiIoTGetValue(id, jsonGet) != 0)
		{
			//printf("SusiIoTGetValue failed. \n");
		}
	}
	json_object_clear(jsonGet);
	json_decref(jsonGet);
	ret = PAUSE();

	printf("Test SusiIoTSetValue\r\n");
	json_t *jsonSet = setDataJson(id);
	for(int i = 0; i < count; i++)
	{
		printf("\r%.2f %%", i * (100 / (float)count));
		if(SusiIoTSetValue(131072, jsonSet) != 0)
		{
			//printf("SusiIoTSetValue failed. \n");
		}
	}
	json_object_clear(jsonSet);
	json_decref(jsonSet);
	ret = PAUSE();
	if (ret == 0) {}
}

void SUSI_IOT_API EventCallBack(SusiIoTId_t id, char *jsonstr)
{
	printf("EventCallBack\nId:0x%d\nData:%s\n", id, jsonstr);
}
int main()
{
	SusiIoTStatus_t status;
	const char *buffer = NULL;
	int32_t op = 0, id = 0, ret = 0;
	char uri[128];

	status = SusiIoTInitialize();

	if(status != 0)
	{
		printf("SusiIoTInitialize() failed. \n");
		printf("Exit the program...\n");
		PAUSE();
		return 0;
	}

	SusiIoTSetPFEventHandler(EventCallBack);

	for (;;)
	{
		ret = CLRSCR();
		title();
		fflush(stdin);
		
		//Neo debug
		ret = SCANF(" %d", &op);
		//op = 5;

		if ((op < 0 || op > 14) && op != 99)
		{
			continue;
		}

		ret = CLRSCR();

		if(op == 0)
		{
			SusiIoTUninitialize();
			return 0;
		}
		else if(op == 1)
		{
			json_t *jsonObject = json_object();

			if(SusiIoTGetPFCapability(jsonObject) != 0)
			{
				printf("\nSusiIoTGetPFCapability failed. \n");
			}
			else
			{
				buffer = json_dumps(jsonObject, JSON_INDENT(4) | JSON_PRESERVE_ORDER | JSON_REAL_PRECISION(10));
				printf("%s\n", buffer);
			}

			json_object_clear(jsonObject);
			json_decref(jsonObject);
		}
		else if(op == 2)
		{
			buffer = SusiIoTGetPFCapabilityString();
			printf("%s\n", buffer);
		}
		else if(op == 3)
		{
			json_t *jtmp = json_object();

			printf("id: ");
			ret = SCANF("%d", &id);

			if(SusiIoTGetPFData(id, jtmp) != 0)
			{
				printf("SusiIoTGetPFData failed. \n");
			}
			else
			{
				buffer = json_dumps(jtmp, JSON_INDENT(4) | JSON_PRESERVE_ORDER | JSON_REAL_PRECISION(10));
				printf("%s\n", buffer);
			}

			json_object_clear(jtmp);
			json_decref(jtmp);
		}
		else if(op == 4)
		{
			printf("id: ");
			ret = SCANF("%d", &id);
			buffer = SusiIoTGetPFDataString(id);
			printf("%s\n", buffer);
		}
		else if(op == 5)
		{
			json_t *jtmp = json_object();

			printf("uri: ");
			getchar();  // clear scanf input buffer
			ret = SCANF("%[^\n]", uri);

			if(SusiIoTGetPFDataByUri(uri, jtmp) != 0)
			{
				printf("SusiIoTGetPFData failed. \n");
			}
			else
			{
				buffer = json_dumps(jtmp, JSON_INDENT(4) | JSON_PRESERVE_ORDER | JSON_REAL_PRECISION(10));
				printf("%s\n", buffer);
			}

			json_object_clear(jtmp);
			json_decref(jtmp);
		}
		else if(op == 6)
		{
			printf("uri: ");
			getchar();  // clear scanf input buffer
			ret = scanf("%[^\n]", uri);
			buffer = SusiIoTGetPFDataStringByUri(uri);
			printf("%s\n", buffer);
		}
		else if(op == 7)
		{
			uint32_t id = 0;
			json_t *jsonObject = getDataJson(id);

			if(SusiIoTGetValue(id, jsonObject) != 0)
			{
				printf("SusiIoTGetValue failed. \n");
			}
			else
			{
				json_t * tmp = json_pack("{s:i, s:o}", "Id", id, "v", jsonObject);
				printf("%s\n", json_dumps(tmp, JSON_INDENT(4) | JSON_PRESERVE_ORDER | JSON_REAL_PRECISION(10)));
				json_object_clear(tmp);
				json_decref(tmp);
			}
		}
		else if(op == 8)
		{
			json_t *jtmp = json_object();
			printf("id: ");
			ret = SCANF("%d", &id);
			if(SusiIoTGetPFData(id, jtmp) != 0)
			{
				printf("SusiIoTGetPFData failed. \n");
			}
			printf("SusiIoTGetPFData\n");
			ret = PAUSE();
			if(SusiIoTSetPFData(jtmp) != 0)
			{
				printf("SusiIoTSetPFData failed. \n");
			}
			printf("SusiIoTSetPFData\n");
			json_object_clear(jtmp);
			json_decref(jtmp);
		}
		else if(op == 9)
		{
			json_t *jtmp = json_object();
			printf("id: ");
			ret = SCANF("%d", &id);
			if(SusiIoTGetPFData(id, jtmp) != 0)
			{
				printf("SusiIoTGetPFData failed. \n");
			}
			printf("SusiIoTGetPFData\n");
			ret = PAUSE();

			buffer = json_dumps(jtmp, 0);
			printf("%s\n", buffer);
			if(SusiIoTSetPFDataString(buffer) != 0)
			{
				printf("SusiIoTSetPFData failed. \n");
			}
			printf("SusiIoTSetPFData\n");
			json_object_clear(jtmp);
			json_decref(jtmp);
		}
		else if(op == 10)
		{
			uint32_t id = 0;
			json_t *jsonObject = setDataJson(id);

			if(SusiIoTSetValue(id, jsonObject) != 0)
			{
				printf("SusiIoTSetValue Failed. \n");
			}
			else
			{
				printf("SusiIoTGetPFData Successfully \n");
			}
			json_object_clear(jsonObject);
			json_decref(jsonObject);
		}
		else if(op == 11)
		{
			SusiIoTLogger(true);
			printf("SusiIoTEnablelogger\n");
		}
		else if(op == 12)
		{
			SusiIoTLogger(false);
			printf("SusiIoTDisablelogger\n");
		}
		else if(op == 13)
		{
			buffer = SusiIoTGetLoggerPath();
			printf("SusiIoT Logger Path:%s\n", buffer);
		}
		else if(op == 14)
		{
			bool logger = SusiIoTGetLoggerStatus();
			printf("SusiIoT Logger Status:%d\n", logger);
		}
		else if(op == 99)
		{
			testfunction();
		}

		if (buffer != NULL)
		{
			SusiIoTMemFree((void *)buffer);
			buffer = NULL;
		}

		ret = PAUSE();

		if (ret == 0) {}
	}

	return 0;
}
