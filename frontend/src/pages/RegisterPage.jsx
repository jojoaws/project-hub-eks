import { useState } from "react";
import Layout from "../components/Layout";
import { FaEye, FaEyeSlash } from "react-icons/fa";
import api from "../services/api";
import { useNavigate } from "react-router-dom";

function RegisterPage() {

  const [fullname, setFullname] = useState("");

  const [email, setEmail] = useState("");

  const [password, setPassword] = useState("");

  const [confirmPassword, setConfirmPassword] = useState("");

  const [showPassword, setShowPassword] = useState(false);

  const [showConfirmPassword, setShowConfirmPassword] = useState(false);

  const  navigate = useNavigate();

  const handleRegister = async (e) => {

    e.preventDefault();

    if (password !== confirmPassword) {

      alert("Passwords do not match");

      return;
    }

    try {

      const response = await api.post(
        "/auth/register",
        {
          full_name: fullname,
          email,
          password
        }
      );

      console.log(response.data);

      alert("Registration successful");

      navigate("/login");

    } catch (error) {

      console.error(error);

      alert(
        error.response?.data?.detail ||
        "Registration failed"
      );

    }

  };

  return (
    <Layout>

      <h1>Register</h1>

      <form onSubmit={handleRegister}>

        <div>
          <label>Full Name</label>
          <br />

          <input
            type="text"
            value={fullname}
            onChange={(e) =>
              setFullname(e.target.value)
            }
          />
        </div>

        <br />

        <div>
          <label>Email</label>
          <br />

          <input
            type="email"
            value={email}
            onChange={(e) =>
              setEmail(e.target.value)
            }
          />
        </div>

        <br />

        <div>
          <label>Password</label>
          <br />

          <input
            type={showPassword ? "text" : "password"}
            value={password}
            onChange={(e) =>
              setPassword(e.target.value)
            }
          />

          <button
            type="button"
            onClick={() =>
              setShowPassword(!showPassword)
            }
          >
            {showPassword ? <FaEyeSlash /> : <FaEye />}
          </button>

        </div>

        <br />

        <div>
          <label>Confirm Password</label>
          <br />

          <input
            type={showConfirmPassword ? "text" : "password"}
            value={confirmPassword}
            onChange={(e) =>
              setConfirmPassword(e.target.value)
            }
          />

          <button
            type="button"
            onClick={() =>
              setShowConfirmPassword(!showConfirmPassword)
            }
          >
            {showConfirmPassword ? <FaEyeSlash /> : <FaEye />}
          </button>

        </div>

        <br />

        <button type="submit">
          Register
        </button>

      </form>

    </Layout>
  );
}

export default RegisterPage;
