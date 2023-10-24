# @summary defines a valid value for the vector systemd service 'ensure' parameter
type Vector::Ensure  = Variant[Enum['running','stopped'],Boolean]
