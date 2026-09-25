import { useEffect, useState } from "react";
import Layout from "../components/Layout";
import { Link } from "react-router-dom";
import api from "../services/api";

function DashboardPage() {

  const [projects, setProjects] = useState([]);

  useEffect(() => {

    const fetchProjects = async () => {

      const token =
        localStorage.getItem("token");

      if (!token) return;

      try {

        const response = await api.get(
          "/projects/",
          {
            headers: {
              Authorization:
                `Bearer ${token}`
            }
          }
        );

        setProjects(
          response.data
        );

      } catch (error) {

        console.error(error);

      }

    };

    fetchProjects();

  }, []);

  return (
    <Layout>

      <h1>Dashboard</h1>

      <p className="dashboard-welcome">
        Welcome back.
      </p>

      <div className="card">

        <h2>Quick Actions</h2>

        <ul className="quick-actions">

         <li>
           → <Link to="/create-project">
             Create Project
           </Link>
        </li>

        <li>
           → <Link to="/profile">
             Manage Profile
         </Link>
       </li>

     </ul>

      </div>

      <div className="card">

        <h2>My Projects</h2>

        {projects.length === 0 ? (

          <p>No projects yet.</p>

        ) : (

          projects.map((project) => (

            <div
              key={project.id}
              className="project-preview"
            >

              <h3>
                {project.title}
              </h3>

              <p>
                {project.description}
              </p>

              <p>
                <strong>
                  Tech Stack:
                </strong>{" "}
                {project.tech_stack}
              </p>

            </div>

          ))

        )}

      </div>

    </Layout>
  );
}

export default DashboardPage;
