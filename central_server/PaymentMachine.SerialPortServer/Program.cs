using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Makers.SmartParking.PaymentMachine.SerialPortServer
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Payment machine serial port server");

            var serialPortInterface = new SerialPortInterface();
            serialPortInterface.PortName = "COM9";

            try
            {
                if (!serialPortInterface.Open())
                {
                    Console.WriteLine("Error opening serial port.");
                }
                else
                {
                    Console.WriteLine("Serial port opened successfuly.");
                }

                Console.ReadLine();
            }
            finally
            {
                serialPortInterface.Close();
            }
        }
    }
}
