import { useState } from "react";
import Layout from "../components/Layout";
import api from "../services/api";
import { useNavigate } from "react-router-dom";

function CreateProjectPage() {

  const [title, setTitle] = useState("");

  const [description, setDescription] = useState("");

  const [techStack, setTechStack] = useState("");

  const [projectImage, setProjectImage] =
    useState(null);

  const navigate = useNavigate();

  const handleSubmit = async (e) => {

    e.preventDefault();

    const token =
      localStorage.getItem("token");

    try {

      const projectResponse =
  await api.post(
    "/projects/",
        {
          title,
          description,
          tech_stack: techStack
        },
        {
          headers: {
            Authorization:
              `Bearer ${token}`
          }
        }
      );

      if (projectImage) {

        const formData =
          new FormData();

        formData.append(
          "file",
          projectImage
        );

        await api.post(
  `/uploads/project-image?project_id=${projectResponse.data.id}`,
          formData,
          {
            headers: {
              Authorization:
                `Bearer ${token}`
            }
          }
        );

      }

      navigate("/projects");

    } catch (error) {

      console.error(error);

      alert(
        error.response?.data?.detail ||
        "Project creation failed"
      );

    }

  };

  return (
    <Layout>

      <h1>Create Project</h1>

      <div className="card">

        <form onSubmit={handleSubmit}>

          <div>

            <label>
              Title
            </label>

            <br />

            <input
              type="text"
              value={title}
              onChange={(e) =>
                setTitle(
                  e.target.value
                )
              }
            />

          </div>

          <br />

          <div>

            <label>
              Description
            </label>

            <br />

            <textarea
              value={description}
              onChange={(e) =>
                setDescription(
                  e.target.value
                )
              }
            />

          </div>

          <br />

          <div>

            <label>
              Technology Stack
            </label>

            <br />

            <input
              type="text"
              value={techStack}
              onChange={(e) =>
                setTechStack(
                  e.target.value
                )
              }
            />

          </div>

          <br />

          <div>

            <label>
              Project Image
            </label>

            <br />

            <input
              type="file"
              accept="image/*"
              onChange={(e) =>
                setProjectImage(
                  e.target.files[0]
                )
              }
            />

          </div>

          <br />

          <button type="submit">

            Create Project

          </button>

        </form>

      </div>

    </Layout>
  );
}

export default CreateProjectPage;
