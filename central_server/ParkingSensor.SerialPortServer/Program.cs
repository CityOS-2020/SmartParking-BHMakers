using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Makers.SmartParking.ParkingSensor.SerialPortServer
{
    class Program
    {
        static void Main(string[] args)
        {
            var serialPortInterface = new SerialPortInterface();

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
