from retry import retry
import pika
from pika.exceptions import AMQPConnectionError,ConnectionWrongStateError,ConnectionClosedByBroker
connection = pika.BlockingConnection(pika.ConnectionParameters(host='52.236.19.78'))
channel = connection.channel()
channel.queue_declare(queue='hello')
def send():
    for i in range(0,1000):
        
        try:
            channel.basic_publish(exchange='', routing_key='quorum', body='Hello World! - {}'.format(i))
            print(" [x] Sent 'Hello World!' - {}".format(i))
        except ConnectionClosedByBroker:
            print('ConnectionClosedByBroker')
            pass
    connection.close()

if __name__ == '__main__':
    send()