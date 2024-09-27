defmodule Writer do

  @moduledoc """
  This module provides functions for writing Employee data to a JSON file.

  ## Special Symbols
  - `defmodule`: Defines a new module
  - `@moduledoc`: Provides documentation for the module
  """

  alias Empresa.Employee

  @doc """
  Writes an Employee struct to a JSON file.

  ## Parameters
  - `employee`: An Empresa.Employee struct to be written
  - `filename`: String, the name of the JSON file to write to (optional, default: "employees.json")

  ## Returns
  - `:ok` if the write operation is successful
  - `{:error, term()}` if an error occurs

  ## Special Symbols
  - `@doc`: Provides documentation for the function
  - `@spec`: Specifies the function's type specification
  - `def`: Defines a public function
  - `\\\\`: Default argument separator
  - `%Employee{}`: Pattern matches an Employee struct
  - `|>`: The pipe operator, passes the result of the previous expression as the first argument to the next function

  ## Examples
      iex> employee = Empresa.Employee.new("Jane Doe", "Manager")
      iex> Writer.write_employee(employee)
      :ok
  """
  @spec write_employee(Employee.t(), String.t()) :: :ok | {:error, term()}
  def write_employee(%Employee{} = employee, filename \\ "employees.json") do
    employees = read_employees(filename)
    new_id = get_next_id(employees)
    updated_employee = Map.put(employee, :id, new_id)
    updated_employees = [updated_employee | employees]

    json_data = Jason.encode!(updated_employees, pretty: true)
    File.write(filename, json_data)
  end

  @doc """
  Removes an Employee from the JSON file by ID.

  ## Parameters
  - `id`: String, the ID of the Employee to remove
  - `filename`: String, the name of the JSON file to write to (optional, default: "employees.json")

  ## Returns
  - `:ok` if the remove operation is successful
  - `{:error, term()}` if an error occurs

  ## Special Symbols
  - `@doc`: Provides documentation for the function
  - `@spec`: Specifies the function's type specification
  - `def`: Defines a public function
  - `\\\\`: Default argument separator
  - `&`: Creates an anonymous function
  - `&1`: Refers to the first argument of the anonymous function
  - `|>`: The pipe operator

  ## Examples
      iex> Writer.remove_employee("1")
      :ok

  """
  @spec remove_employee(String.t(), String.t()) :: :ok | {:error, term()}
  def remove_employee(id, filename \\ "employees.json") do
    employees = read_employees(filename)
    updated_employees = Enum.reject(employees, &(&1.id == id))

    json_data = Jason.encode!(updated_employees, pretty: true)
    File.write(filename, json_data)
  end

  @doc """
  Exports the employees to a YAML file.

  ## Parameters
  - `filename`: String, the name of the YAML file to write to (optional, default: "employees.yaml")

  ## Returns
  - `:ok` if the export operation is successful
  - `{:error, term()}` if an error occurs

  ## Special Symbols
  - `@doc`: Provides documentation for the function
  - `@spec`: Specifies the function's type specification
  - `def`: Defines a public function
  - `\\\\`: Default argument separator
  - `|>`: The pipe operator

  ## Examples
      iex> Writer.export_employees_to_yaml("employees.yaml")
      :ok
  """
  def export_employees_to_yaml(filename \\ "employees.json") do
    employees = read_employees(filename)
    yaml = Ymlr.document!(employees)
    File.write("employees.yaml", yaml)
  end

  @doc """
  Reads existing employees from the JSON file.

  ## Parameters
  - `filename`: String, the name of the JSON file to read from

  ## Returns
  - List of Employee structs

  ## Special Symbols
  - `@doc`: Provides documentation for the function
  - `@spec`: Specifies the function's type specification
  - `defp`: Defines a private function
  - `case`: Pattern matches on the result of an expression

  ## Examples
      iex> Writer.read_employees("employees.json")
      [%Empresa.Employee{...}, ...]
  """
  @spec read_employees(String.t()) :: [Employee.t()]
  defp read_employees(filename) do
    case File.read(filename) do
      {:ok, contents} ->
        Jason.decode!(contents, keys: :atoms)
        |> Enum.map(&struct(Employee, &1))
      {:error, :enoent} -> []
    end
  end



  @doc """
  Generates the next available ID for a new employee.

  ## Parameters
  - `employees`: List of existing Employee structs

  ## Returns
  - Integer, the next available ID

  ## Special Symbols
  - `@doc`: Provides documentation for the function
  - `@spec`: Specifies the function's type specification
  - `defp`: Defines a private function
  - `&`: Creates an anonymous function
  - `&1`: Refers to the first argument of the anonymous function
  - `|>`: The pipe operator

  ## Examples
      iex> employees = [%Empresa.Employee{id: 1, ...}, %Empresa.Employee{id: 2, ...}]
      iex> Writer.get_next_id(employees)
      3
  """
  @spec get_next_id([Employee.t()]) :: integer()
  defp get_next_id(employees) do
    employees
    |> Enum.map(& &1.id)
    |> Enum.max(fn -> 0 end)
    |> Kernel.+(1)
  end
end
