import Maindashboard from "./pages/dashboard/maindashboard";
import SidePanel from "./components/sidepanel/sidepanel";
import Footer from "./components/footer/footer";
import Header from "./components/header/header";
import HomePage from './webpages/page'
import Navbar from "./webcomponents/Navbar";



export default function Home() {
  // function isWithinThreeMonths(dateString) {
  //   const date = new Date(dateString);
  //   const currentDate = new Date();
  //   const threeMonthsLater = new Date(date);
  //   threeMonthsLater.setMonth(threeMonthsLater.getMonth() + 6);

  //   return currentDate <= threeMonthsLater;
  // }

  // const dateString = "2024-11-01";


  // if (!isWithinThreeMonths(process.env.ACTIVE_DATE)) {
  //   return (
  //     <div>
  //       {" "}
  //       Contact the software engineer on +233551577446 to retify the issue{" "}
  //     </div>
  //   );
  // }

  return (
    <>
    < Navbar />
    <HomePage />
    </>
  );
}
