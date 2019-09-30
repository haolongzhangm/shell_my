**************************************************
char *reversal(char *str)
{
	char *start = str;
	char *end = str;
	char tmp;

	if (NULL != str)
	{
		while (*end++)
			;//find the end pointer of str 
		end -= 2;

		for(; start < end; start++, end--)
		{
			tmp = *start;
			*start = *end;
			*end = tmp;
		}
	}

	return start;
}
*************************************************

char *strcpy(char *str_dest, char *str_src)
{
	if (NULL == str_dest || NULL == str_src)
		retrun NULL;

	if (str_dest == str_src)
		retrun str_dest;

	char *tmp = str_dest;
	while('\0' != (*str_src++ = *str_src++))
		retrun tmp;
}
**************************************************
int strlen(const char *ctr)
{
	if (NULL == str)
		return 0;

	int len;
	while('\0' != (*str++))
		len++;

	return len;
}
**************************************************
void strswap(char **str1, char **str2)
{
	char *tmp = *str1;
	*str1= *str2;
	*str2 = tmp;
}

void strswap(char *str1, char *str2)
{
	char tmp;
	int i = 0;

	strcpy(&tmp, str1);
	strcpy(str1, str2);
	strcpy(str2, str1);
}
****************************************************
list_head *reverse(list_head, *head)
{
	list_head *p1, *p2, *p3;
	if (head == NULL || head->next == NULL)
	{
		return head;
	}

	p1 = head;
	p2 = head->next;

	while(p2)
	{
		p3 = p2->next;
		p2->next = p1;
		p1 = p2;
		pp2= p3;
	}
	
	head->next = NULL;
	head = p1;

	return head;
}

******************************************************

void search_mid(list_head, *head, list_head, *mid)
{
	list_head *tmp1, tmp2;
	tmp1 = head;
	tmp2 = head;

	while(tmp2->next->next != null)
	{
		tmp2 = tmp2->next->next;
		tmp1 = tmp1->next;
		mid = tmp1;
	}
}

********************************************************




