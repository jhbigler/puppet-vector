# @summary defines a valid value for the 'enabled' parameter for the vector systemd service
type Vector::Enabled = Variant[Enum['manual','mask','delayed'],Boolean]
