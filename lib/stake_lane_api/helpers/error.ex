defmodule StakeLaneApi.Helpers.Errors do
  def treated_error(message, status \\ 400) do
    { :treated_error,
      %{
        message: message,
        status: status
      }
    }
  end
end
