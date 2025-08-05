function P_proj = projectPointOntoLine(A, B, P)
% projectPointOntoLine is a function used to project scattered point P onto line AB and return projection point
%{
    input:
        A & B & P: 1x3 vector
    output:
        P_proj: 1x3 vector
%}
    distance = B - A;
    unit = distance / norm(distance);
    P_proj = A + unit * dot(P - A, unit);
end