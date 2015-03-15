using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO.Ports;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace Makers.SmartParking.PaymentMachine.SerialPortServer
{
    /// <summary> 
    /// Interfaces with a serial port. There should only be one instance 
    /// of this class for each serial port to be used. 
    /// </summary> 
    public class SerialPortInterface
    {
        private SerialPort _serialPort = new SerialPort();
        private int _baudRate = 9600;
        private int _dataBits = 8;
        private Handshake _handshake = Handshake.None;
        private Parity _parity = Parity.None;
        private string _portName = "COM42";
        private StopBits _stopBits = StopBits.One;

        private int parkingId = 4; // Hrasno bosmal
        private int placeId = 5;

        /// <summary> 
        /// Holds data received until we get a terminator. 
        /// </summary> 
        private string tString = string.Empty;
        /// <summary> 
        /// End of transmition byte in this case EOT (ASCII 4). 
        /// </summary> 
        private byte _terminator = 0x4;

        public int BaudRate { get { return _baudRate; } set { _baudRate = value; } }
        public int DataBits { get { return _dataBits; } set { _dataBits = value; } }
        public Handshake Handshake { get { return _handshake; } set { _handshake = value; } }
        public Parity Parity { get { return _parity; } set { _parity = value; } }
        public string PortName { get { return _portName; } set { _portName = value; } }

        public bool Open()
        {
            try
            {
                _serialPort.BaudRate = _baudRate;
                _serialPort.DataBits = _dataBits;
                _serialPort.Handshake = _handshake;
                _serialPort.Parity = _parity;
                _serialPort.PortName = _portName;
                _serialPort.StopBits = _stopBits;
                _serialPort.DataReceived += new SerialDataReceivedEventHandler(_serialPort_DataReceived);

                _serialPort.Open();
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                return false;
            }
            return true;
        }

        public void Close()
        {
            _serialPort.Close();
        }

        private string lastStatus = null;

        async void _serialPort_DataReceived(object sender, SerialDataReceivedEventArgs e)
        {
            //Initialize a buffer to hold the received data 
            byte[] buffer = new byte[_serialPort.ReadBufferSize];

            //There is no accurate method for checking how many bytes are read 
            //unless you check the return from the Read method 
            int bytesRead = _serialPort.Read(buffer, 0, buffer.Length);

            using (WebClient client = new WebClient())
            {
                var placeCode = buffer[0].ToString();
                var duration = Convert.ToDouble(buffer[1]);
                Console.WriteLine(String.Format("Paying place {0} for {1} hours.", placeCode, duration));
                
                NameValueCollection reqparm = new NameValueCollection();
                reqparm.Add("parkingId", parkingId.ToString());
                reqparm.Add("parkingPlaceCode", placeCode);
                reqparm.Add("duration", TimeSpan.FromHours(duration).ToString());

                await client.UploadValuesTaskAsync(new Uri("http://preview.hardver.ba/parkings/api/unauthorized-payment"), "POST", reqparm);
                var response = client.ResponseHeaders;
            }
        }

    } 
}
