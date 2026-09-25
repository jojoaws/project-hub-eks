import { useEffect, useState } from "react";
import Layout from "../components/Layout";
import api from "../services/api";

function ProjectsPage() {

  const [projects, setProjects] = useState([]);

  useEffect(() => {

    const fetchProjects = async () => {

      const token =
        localStorage.getItem("token");

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

      <h1>Projects</h1>

      {projects.length === 0 ? (

        <p>No projects found.</p>

      ) : (

        projects.map((project) => (

          <div
            key={project.id}
            className="card project-card"
          >

            <div className="project-image">

              {project.project_image ? (

                <img
                  src={project.project_image}
                  alt="Project"
                  style={{
                    width: "100%",
                    height: "200px",
                    objectFit: "cover",
                    borderRadius: "12px"
                  }}
                />

              ) : (

                "Project Image"

              )}

            </div>

            <h2>
              {project.title}
            </h2>

            <p className="project-description">
              {project.description}
            </p>

            <p className="project-stack">
              🏷 {project.tech_stack}
            </p>

          </div>

        ))

      )}

    </Layout>
  );
}

export default ProjectsPage;
