//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract FabricaContract {
    uint public idDigits = 16;
    struct Producto {
        string nombre;
        uint identificacion;
    }
    Producto[] productos;

    function _crearProducto(string memory _nombre, uint _id) private {
        productos.push(Producto(_nombre, _id));
        emit NuevoProducto(productos.length-1, _nombre, _id);
    }

    function _generarIdAleatorio(string memory _str)
        private
        view
        returns (uint rand)
    {
        uint idModulus = 10 ^ idDigits;
        rand = uint(keccak256(abi.encodePacked(_str))) % idModulus;
    }

    function crearProductoAleatorio(string memory _nombre) public {
        uint _randId = _generarIdAleatorio(_nombre);
        _crearProducto(_nombre, _randId);
    }

    event NuevoProducto(uint ArrayProductId, string nombre, uint id);

    mapping(uint => address) public productoAPropietario;

    mapping(address => uint) public propietarioProductos;

    function propiedad(uint productoId) public {
        productoAPropietario[productoId] = msg.sender;
        propietarioProductos[msg.sender] = propietarioProductos[msg.sender] + 1;
    }

    function getProductosPorPropietario(address _propietario)
        external
        view
        returns (uint[] memory)
    {
        uint contador = 0;
        uint[] memory resultado = new uint[](propietarioProductos[_propietario]);

        for (uint x = 0; x < productos.length; x++) {
            uint id = productos[x].identificacion;
            if ( productoAPropietario[id] == _propietario) {
                resultado[contador] = productos[x].identificacion;
                contador = contador+1;  
            }
        }
        return resultado;
    }
}
