def Hello(event, context):
    message = 'Hello {} {}!'.format("From Lambda", "-------------")  
    return { 
        'message' : message
    }  