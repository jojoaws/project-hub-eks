import { useEffect, useState } from "react";
import Layout from "../components/Layout";
import api from "../services/api";
import { FaEdit } from "react-icons/fa";

function ProfilePage() {

  const [user, setUser] =
    useState(null);

  const [bio, setBio] =
    useState("");

  const [editingBio, setEditingBio] =
    useState(false);

  useEffect(() => {

    const fetchProfile = async () => {

      const token =
        localStorage.getItem("token");

      if (!token) return;

      try {

        const response =
          await api.get(
            "/users/me",
            {
              headers: {
                Authorization:
                  `Bearer ${token}`
              }
            }
          );

        setUser(
          response.data
        );

        setBio(
          response.data.bio || ""
        );

      } catch (error) {

        console.error(error);

      }

    };

    fetchProfile();

  }, []);

  const saveBio = async () => {

    const token =
      localStorage.getItem("token");

    try {

      await api.put(
        "/users/me/bio",
        {
          bio
        },
        {
          headers: {
            Authorization:
              `Bearer ${token}`
          }
        }
      );

      setEditingBio(false);

      alert(
        "Bio updated"
      );

    } catch (error) {

      console.error(error);

    }

  };

  const uploadProfilePicture = async (file) => {

    if (!file) return;

    const token =
      localStorage.getItem("token");

    const formData =
      new FormData();

    formData.append(
      "file",
      file
    );

    try {

      await api.post(
        "/uploads/profile-picture",
        formData,
        {
          headers: {
            Authorization:
              `Bearer ${token}`
          }
        }
      );

      alert(
        "Profile picture uploaded"
      );

    } catch (error) {

      console.error(error);

      alert(
        error.response?.data?.detail ||
        "Upload failed"
      );

    }

  };

  const uploadResume = async (file) => {

    if (!file) return;

    const token =
      localStorage.getItem("token");

    const formData =
      new FormData();

    formData.append(
      "file",
      file
    );

    try {

      await api.post(
        "/uploads/resume",
        formData,
        {
          headers: {
            Authorization:
              `Bearer ${token}`
          }
        }
      );

      alert(
        "Resume uploaded"
      );

    } catch (error) {

      console.error(error);

      alert(
        error.response?.data?.detail ||
        "Upload failed"
      );

    }

  };

  return (
    <Layout>

      <h1>Profile</h1>

      <div className="card profile-card">

        <div className="avatar-section">

          <input
            type="file"
            accept="image/*"
            id="profile-picture-upload"
            style={{
              display: "none"
            }}
            onChange={(e) =>
              uploadProfilePicture(
                e.target.files[0]
              )
            }
          />

          <div className="profile-picture">

  {user?.profile_picture ? (

    <img
      src={user.profile_picture}
      alt="Profile"
      style={{
        width: "150px",
        height: "150px",
        borderRadius: "50%",
        objectFit: "cover"
      }}
    />

  ) : (

    "👤"

  )}

</div>

          <button
            className="edit-icon"
            onClick={() =>
              document
                .getElementById(
                  "profile-picture-upload"
                )
                .click()
            }
          >
            <FaEdit />
          </button>

        </div>

        <h2>
          {user?.full_name}
        </h2>

        <p className="profile-email">
          {user?.email}
        </p>

        <div className="bio-section">

          <div className="bio-header">

            <h3>
              Bio
            </h3>

            <button
              className="edit-icon"
              onClick={() =>
                setEditingBio(
                  !editingBio
                )
              }
            >
              <FaEdit />
            </button>

          </div>

          {editingBio ? (

            <>
              <textarea
                value={bio}
                onChange={(e) =>
                  setBio(
                    e.target.value
                  )
                }
                rows="4"
                style={{
                  width: "100%"
                }}
              />

              <br />
              <br />

              <button
                onClick={saveBio}
              >
                Save Bio
              </button>

            </>

          ) : (

            <p className="bio-text">

              {bio ||
                "Tell the world about yourself"}

            </p>

          )}

        </div>

        <div className="bio-section">

  <h3>
    Resume
  </h3>

  <p>
    Upload your resume (PDF only)
  </p>

  {user?.resume_url && (
    <p>
      <a
        href={user.resume_url}
        target="_blank"
        rel="noreferrer"
      >
        📄 View Resume
      </a>
    </p>
  )}

  <button
    onClick={() =>
      document
        .getElementById(
          "resume-upload"
        )
        .click()
    }
  >

    Upload Resume
  </button>

  <input
  id="resume-upload"
  type="file"
  accept=".pdf"
  style={{
    display: "none"
  }}
  onChange={(e) => {
    const file = e.target.files[0];

    if (file) {
      uploadResume(file);
    }
  }}
/>

</div>

      </div>

    </Layout>
  );
}

export default ProfilePage;
