##### Api now closed and the sample is not working. But you can see the logic.

The application receives from server the meta information for building dynamic registration form. The meta information get the number of lines, type of the values in line and name ​​of the form. Strings can contain text values​, numbers, or a list .

The user enters data into the form and it is sent to the server. The interaction occurs by REST with sending POST requests.

###Description of the interaction with the server:

Request for meta information: POST http://test.clevertec.ru/meta
Answer: JSON-объект
```
{
        "title": "<name Form>"
        "fields": [{
                "title": "<display name>",
                "name": "<software name>",
                "type": "<field type(TEXT, NUMERIC, LIST>",
                "values": < possible values if type = LIST >
            }, {
                ...
            },
            ...
        ]
    }
```
---- 

Request for send data: POST http://test.clevertec.ru/data/
```
{
  "form": {
     "<software name line 1>": "<value line 1>",
     "<software name line  2>": "<value line 2>",
     …
  }
}
```

Answer: JSON-object
```
{
  "result": "<result string>"
}
```
