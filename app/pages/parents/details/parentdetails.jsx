// pages/dashboard/users/index.js
"use client";

import React, { useState, useEffect } from "react";
import {
  FaUsers,
  FaUserPlus,
  FaEdit,
  FaInfoCircle,
  FaUserShield,
  FaChartBar,
  FaTrash,
  FaPaperclip,
  FaLink,
} from "react-icons/fa";
import {
  PieChart,
  Pie,
  Cell,
  ResponsiveContainer,
  Tooltip,
  Legend,
} from "recharts";
import StatCard from "../../components/statcard";
import Modal from "../../components/modal/modal";
import CustomTable from "../../components/listtableForm";
import { useSession } from "next-auth/react";
import { fetchData } from "../../config/configFile";
import LoadingPage from "../../components/generalLoadingpage";
import EditRolesAndPermissions from "./asignRolesAndPermissions/assignrolesnpermissions";
import AssignUserRoles from "./assignUsersRoles/assignuserroles";
import { toast } from "react-toastify";
import DeleteUser from "../../components/deleteuser";
import { useRouter } from "next/navigation";


const ParentManagement = () => {
  const { data: session, status } = useSession();

    const router = useRouter();


  const [searchQuery, setSearchQuery] = useState("");
  const [showModal, setShowModal] = useState(false);
  const [modalContent, setModalContent] = useState(null);
  const [users, setUsers] = useState([]);
  const [userStats, setUserStats] = useState([]);
  const headerNames = ["id", "Name", "Tel", 'No. of Students'];
  const [isAuthorised, setIsAuthorised] = useState(false);
  const [isLoading, setIsLoading] = useState(true);
  const [sender_id, setSender_id] = useState();
      const authorizedPermissions2 = ["view parents"];


  useEffect(() => {
    setIsLoading(true);
    fetchUsers();
    setIsLoading(false);
  }, []);

  useEffect(() => {
    if (
      status === "authenticated" &&
      session?.user?.activeSemester?.semester_id
    ) {
      const activeSemester = session?.user?.activeSemester?.semester_id;
      setSender_id(session?.user?.id);
      console.log("session?.user?.id", session?.user?.id);
      // setActiveSem(activeSemester);
      // fetchFinancialStats(activeSemester);
      setIsLoading(false);
    }

    const authorizedRoles = ["admin", "head teacher", 'teaching staff'];
    const authorizedPermissions = ["view parents"];

    if (
      session?.user?.permissions?.some((permission) =>
        authorizedPermissions.includes(permission)
      ) ||      
        authorizedRoles.includes(session?.user?.role)
    ) {
      setIsAuthorised(true);
    } else {
      setIsAuthorised(false);
    }
  }, [session, status]);

  const handleSearchInputChange = (e) => {
    setSearchQuery(e.target.value);
    fetchUsers(e.target.value);
  };

  const fetchUsers = async (searchQuery1 = "") => {
    let url = "/api/parents/getactiveparents/";
    if (searchQuery1.trim() !== "") {
      url += `?query=${encodeURIComponent(searchQuery1)}`;
    }

    const data = await fetchData(url, "", false);
    setUsers(data);
    // setUserStats(data);
  };


   const handleOpenLink = (parentId) => {
     console.log("class id", parentId);

     setModalContent(
       <div>
         <LoadingPage />
       </div>
     );
     setShowModal(true);

     router.push(`/pages/classes/details/${parentId}`);

     setShowModal(false);
   };
 
  const handleDeleteUser = async (user_id) => {
    try {
      console.log("handleDeleteUser", user_id);
      // const [parentsData, classesData] = await Promise.all([
      //   fetchData("/api/parents/getallparents", "", false),
      //   fetchData("/api/classes/all", "", true),
      // ]);
      setModalContent(
        <div>
          <DeleteUser
            userData={user_id}
            onClose={() => setShowModal(false)}
            onDelete={async () => {
              const toastId = toast.loading("Processing your request...");

              const userdata = {
                sender_id: sender_id,
              };
              try {
                const response = await fetch(
                  `/api/users/deleteuser/${user_id}`,
                  {
                    method: "PUT",
                    headers: {
                      "Content-Type": "application/json",
                    },
                    body: JSON.stringify(userdata),
                  }
                );
                const result = await response.json();

                if (!response.ok) {
                  const errorMessage =
                    result.error || "Failed to delete user12.";
                  toast.update(toastId, {
                    render: errorMessage,
                    type: "error",
                    isLoading: false,
                    autoClose: 2000,
                  });
                  return;
                }

                // Add API call to delete teacher
                console.log("Deleting user:", user_id);
                await fetchUsers();
                // toast.success("User deleted successfully...");
                toast.update(toastId, {
                  render: "User deleted successfully...",
                  type: "success",
                  isLoading: false,
                  autoClose: 2000,
                });
                setShowModal(false);
                // alert("user deleted successfully!");
              } catch (error) {
                console.error("Error deleting user:", error);
                // toast.error("An error occurred. Please try again.");
                toast.update(toastId, {
                  render: "An error occurred. Please try again.",
                  type: "error",
                  isLoading: false,
                  autoClose: 2000,
                });

                // alert("An error occurred. Please try again.");
              }
            }}
          />
        </div>
      );
    } catch (error) {
      console.log(error);
    } finally {
      setShowModal(true);
    }
  };

  if (status === "loading" || isLoading) {
    return (
      <div className="text-cyan-700">
        <LoadingPage />
      </div>
    );
  }

  if (!isAuthorised) {
    return (
      <div className="flex items-center">
        You are not authorised to be on this page
      </div>
    );
  }

  const COLORS = [
    "#0088FE",
    "#00C49F",
    "#FFBB28FF",
    "#FF8042",
    "#AE3E49",
    "#0E7490",
  ];

  return (
    <>
      <div className="pb-16 text-cyan-600">
        <h1 className="text-3xl font-bold mb-6 text-cyan-700">
          User Management
        </h1>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
          <StatCard
            icon={<FaUsers />}
            title="Total Parents"
            value={users?.length}
          />
          <StatCard
            icon={<FaChartBar />}
            title="Staff"
            value={userStats?.totalstaffcount}
          />
          <StatCard
            icon={<FaChartBar />}
            title="Students"
            value={userStats?.studentstotal}
          />

          <StatCard
            icon={<FaChartBar />}
            title="Parents"
            value={userStats?.totalparentcount}
          />
        </div>
        <div className="bg-white p-4 rounded shadow mb-6">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-xl font-semibold text-cyan-700">Parents  List</h2>
          </div>
          <div className="overflow-x-auto tableWrap">
            <CustomTable
              data={users}
              headerNames={headerNames}
              maxTableHeight="40vh"
              height="20vh"
              handleEdit={handleOpenLink}
              searchTerm={searchQuery}
              handleSearch={handleSearchInputChange}
              searchPlaceholder="Search with user name, role or email"
              displayDelBtn={false}
              displayDetailsBtn={false}
              editIcon={<FaLink />}
              editTitle="delete user with id "
              displayActions={session?.user?.role === "admin" || session?.user?.permissions?.some((permission) =>
                authorizedPermissions2.includes(permission))}
            />
          </div>
        </div>
       
      </div>
      {showModal && (
        <Modal onClose={() => setShowModal(false)}>{modalContent}</Modal>
      )}
    </>
  );
};

export default ParentManagement;
